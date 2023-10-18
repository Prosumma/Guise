//
//  Entry.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

import Foundation

class Entry: Resolvable {
  /// Used by the unit tests. Expressed in nanoseconds.
  static var singletonTestDelay: UInt64 = 0

  /// Used by the unit tests. If this is set, `Entry` throws this error when resolving.
  static var testResolutionError: Error?

  private let lock: DispatchQueue
  private let asyncLock = AsyncLock()
  private let factory: Factory
  private var resolution: Resolution = .factory

  let lifetime: Lifetime

#if swift(>=5.9)
  init<T, each A>(
    key: Key,
    lifetime: Lifetime,
    factory: @escaping (any Resolver, repeat each A) throws -> T
  ) {
    self.lock = Self.lock(from: key)
    self.lifetime = lifetime
    self.factory = .sync { resolver, arg in
      let args = arg as! (repeat each A)
      return try factory(resolver, repeat each args)
    }
  }

  init<T, each A>(
    key: Key,
    lifetime: Lifetime,
    factory: @escaping (any Resolver, repeat each A) async throws -> T
  ) {
    self.lock = Self.lock(from: key)
    self.lifetime = lifetime
    self.factory = .async { resolver, arg in
      let args = arg as! (repeat each A)
      return try await factory(resolver, repeat each args)
    }
  }
#else
  init<T, A>(
    key: Key,
    lifetime: Lifetime,
    factory: @escaping (any Resolver, A) throws -> T
  ) {
    self.lock = Self.lock(from: key)
    self.lifetime = lifetime
    self.factory = .sync { resolver, arg in
      try factory(resolver, arg as! A)
    }
  }

  init<T, A>(
    key: Key,
    lifetime: Lifetime,
    factory: @escaping (any Resolver, A) async throws -> T
  ) {
    self.lock = Self.lock(from: key)
    self.lifetime = lifetime
    self.factory = .async { resolver, arg in
      try await factory(resolver, arg as! A)
    }
  }
#endif
  
  func resolve(_ resolver: any Resolver, _ argument: Any) throws -> Any {
    try Entry.testResolutionError.flatMap { throw $0 }
    switch resolution {
    case .instance(let instance):
      return instance
    case .factory:
      switch lifetime {
      case .transient:
        return try run(factory: factory, with: resolver, argument: argument)
      case .singleton:
        switch factory {
        case .sync(let factory):
          return try resolveSingleton(factory: factory, with: resolver, argument: argument)
        case .async(let factory):
          guard ResolutionConfig.allowSynchronousResolutionOfAsyncEntries else {
            throw ResolutionError.Reason.requiresAsync
          }
          return try runBlocking {
            try await self.resolveSingleton(factory: factory, with: resolver, argument: argument)
          }
        }
      }
    }
  }

  func resolve(_ resolver: any Resolver, _ argument: Any) async throws -> Any {
    try Entry.testResolutionError.flatMap { throw $0 }
    switch resolution {
    case .instance(let instance):
      return instance
    case .factory:
      switch lifetime {
      case .transient:
        return try await run(factory: factory, with: resolver, argument: argument)
      case .singleton:
        switch factory {
        case .async(let factory):
          return try await resolveSingleton(factory: factory, with: resolver, argument: argument)
        case .sync(let factory):
          return try resolveSingleton(factory: factory, with: resolver, argument: argument)
        }
      }
    }
  }

  private func resolveSingleton(
    factory: (any Resolver, Any) throws -> Any,
    with resolver: any Resolver,
    argument: Any
  ) throws -> Any {
    try lock.sync {
      Thread.sleep(forTimeInterval: TimeInterval(Entry.singletonTestDelay) / .nanosecondsPerSecond)
      switch resolution {
      case .instance(let instance):
        return instance
      case .factory:
        let instance = try run(factory: factory, with: resolver, argument: argument)
        self.resolution = .instance(instance)
        return instance
      }
    }
  }

  private func resolveSingleton(
    factory: (any Resolver, Any) async throws -> Any,
    with resolver: any Resolver,
    argument: Any
  ) async throws -> Any {
    try await asyncLock.lock {
      try await Task.sleep(nanoseconds: Entry.singletonTestDelay)
      switch resolution {
      case .instance(let instance):
        return instance
      case .factory:
        let instance = try await run(factory: factory, with: resolver, argument: argument)
        self.resolution = .instance(instance)
        return instance
      }
    }
  }

  private func run(
    factory: (any Resolver, Any) throws -> Any,
    with resolver: Resolver,
    argument: Any
  ) throws -> Any {
    let result: Any
    do {
      result = try factory(resolver, argument)
    } catch {
      throw ResolutionError.Reason.error(error)
    }
    return result
  }

  private func run(
    factory: (any Resolver, Any) async throws -> Any,
    with resolver: Resolver,
    argument: Any
  ) async throws -> Any {
    let result: Any
    do {
      result = try await factory(resolver, argument)
    } catch {
      throw ResolutionError.Reason.error(error)
    }
    return result
  }

  private func run(
    factory: (any Resolver, Any) throws -> Any,
    with resolver: Resolver,
    argument: Any
  ) async throws -> Any {
    let result: Any
    do {
      result = try factory(resolver, argument)
    } catch {
      throw ResolutionError.Reason.error(error)
    }
    return result
  }

  private func run(
    factory: Factory,
    with resolver: Resolver,
    argument: Any
  ) throws -> Any {
    switch factory {
    case .sync(let factory):
      return try run(factory: factory, with: resolver, argument: argument)
    case .async(let factory):
      guard ResolutionConfig.allowSynchronousResolutionOfAsyncEntries else {
        throw ResolutionError.Reason.requiresAsync
      }
      return try runBlocking {
        try await factory(resolver, argument)
      }
    }
  }

  private func run(
    factory: Factory,
    with resolver: Resolver,
    argument: Any
  ) async throws -> Any {
    switch factory {
    case .sync(let factory):
      return try await run(factory: factory, with: resolver, argument: argument)
    case .async(let factory):
      return try await run(factory: factory, with: resolver, argument: argument)
    }
  }
}

private extension Entry {
  static func lock(from key: Key) -> DispatchQueue {
    DispatchQueue(label: "Guise Entry lock for \(key)")
  }
}

private extension Entry {
  enum Factory {
    case sync((any Resolver, Any) throws -> Any)
    case `async`((any Resolver, Any) async throws -> Any)
  }

  enum Resolution {
    case instance(Any)
    case factory
  }
}

private extension TimeInterval {
  static let nanosecondsPerSecond: TimeInterval = 1_000_000
}
