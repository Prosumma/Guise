//
//  Entry.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

import Foundation

public class Entry {
  /**
   Allows for the synchronous resolution of `async` entries
   using the `runBlocking` function.
   
   This is disabled by default because it is mildly dangerous
   and could cause deadlocks. Read the documentation for
   `runBlocking` and enable at your own risk!
   
   If most of your DI resolution occurs in the main thread, it's
   reasonably safe to enable this.
   
   If you want to enable this, set it to `true` before any resolution
   of entries occurs.
   */
  public static var allowSynchronousResolutionOfAsyncEntries = false

  /// Used by the unit tests. Expressed in nanoseconds.
  static var singletonTestDelay: UInt64 = 0

  /// Used by the unit tests. If this is set, `Entry` throws this error when resolving.
  static var testResolutionError: Error?

  private let lock: DispatchQueue
  private let asyncLock = AsyncLock()
  private let factory: Factory
  private let lifetime: Lifetime
  private var resolution: Resolution = .factory

  init<T, A>(
    key: Key,
    lifetime: Lifetime,
    factory: @escaping (any Resolver, A) throws -> T
  ) {
    self.lock = DispatchQueue(label: "Guise Entry Lock for \(key)")
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
    self.lock = DispatchQueue(label: "Guise Entry Lock for \(key)")
    self.lifetime = lifetime
    self.factory = .async { resolver, arg in
      try await factory(resolver, arg as! A)
    }
  }

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
          guard Entry.allowSynchronousResolutionOfAsyncEntries else {
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
    do {
      return try factory(resolver, argument)
    } catch {
      throw ResolutionError.Reason.error(error)
    }
  }
  
  private func run(
    factory: (any Resolver, Any) async throws -> Any,
    with resolver: Resolver,
    argument: Any
  ) async throws -> Any {
    do {
      return try await factory(resolver, argument)
    } catch {
      throw ResolutionError.Reason.error(error)
    }
  }
  
  private func run(
    factory: (any Resolver, Any) throws -> Any,
    with resolver: Resolver,
    argument: Any
  ) async throws -> Any {
    do {
      return try factory(resolver, argument)
    } catch {
      throw ResolutionError.Reason.error(error)
    }
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
      guard Entry.allowSynchronousResolutionOfAsyncEntries else {
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
  enum Factory {
    case sync((any Resolver, Any) throws -> Any)
    case `async`((any Resolver, Any) async throws -> Any)
  }

  enum Resolution {
    case instance(Any)
    case factory
  }
}

extension TimeInterval {
  static let nanosecondsPerSecond: TimeInterval = 1_000_000
}
