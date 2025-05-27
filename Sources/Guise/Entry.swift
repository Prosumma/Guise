//
//  Entry.swift
//  Guise
//
//  Created by Gregory Higley on 2024-11-05.
//

import Foundation
import Semaphore

// swiftlint:disable cyclomatic_complexity

/// This class represents a single entry in the container.
/// 
/// Although this class is public, most of its state is private.
/// It is not intended to be used directly by clients of Guise.
public class Entry: @unchecked Sendable {
  private enum Resolution {
    case instance(Any)
    case factory
  }

  private enum Factory {
    case sync(@Sendable (any Resolver, Any) throws -> Any)
    case async(@Sendable (any Resolver, Any) async throws -> sending Any)
    case main(@MainActor @Sendable (any Resolver, Any) throws -> Any)
  }

  public let key: AnyKey
  public let lifetime: Lifetime
  private let factory: Factory
  private var resolution: Resolution = .factory
  private let lock = DispatchQueue(label: "Guise.Entry.lock")
  private let semaphore = AsyncSemaphore(value: 1)

  init<T, each Arg: Sendable>(
    key: Key<T>,
    lifetime: Lifetime,
    factory: @escaping @Sendable (any Resolver, repeat each Arg) throws -> T
  ) {
    self.key = AnyKey(key)
    self.lifetime = lifetime
    self.factory = .sync { resolver, args in
      guard let args = args as? (repeat each Arg) else {
        throw ResolutionError(key, reason: .invalidArgsType)
      }
      return try factory(resolver, repeat each args)
    }
  }

  init<T, each Arg: Sendable>(
    key: Key<T>,
    lifetime: Lifetime,
    factory: @escaping @Sendable (any Resolver, repeat each Arg) async throws -> T
  ) {
    self.key = AnyKey(key)
    self.lifetime = lifetime
    self.factory = .async { resolver, args in
      guard let args = args as? (repeat each Arg) else {
        throw ResolutionError(key, reason: .invalidArgsType)
      }
      return try await factory(resolver, repeat each args)
    }
  }

  init<T, each Arg: Sendable>(
    key: Key<T>,
    lifetime: Lifetime,
    isolation: MainActor,
    factory: @escaping @MainActor @Sendable (any Resolver, repeat each Arg) throws -> T
  ) {
    self.key = AnyKey(key)
    self.lifetime = lifetime
    self.factory = .main { resolver, args in
      guard let args = args as? (repeat each Arg) else {
        throw ResolutionError(key, reason: .invalidArgsType)
      }
      return try factory(resolver, repeat each args)
    }
  }

  func resolve<each Arg: Sendable>(
    with resolver: any Resolver,
    args: repeat each Arg
  ) throws -> Any {
    try resolveSync(with: resolver, args: repeat each args)
  }

  func resolve<each Arg: Sendable>(
    with resolver: any Resolver,
    args: repeat each Arg
  ) async throws -> Any {
    switch resolution {
    case .instance(let instance):
      return instance
    case .factory:
      switch factory {
      case .sync:
        return try resolveSync(with: resolver, args: (repeat each args))
      case .async(let resolve):
        switch lifetime {
        case .transient:
          return try await resolve(resolver, (repeat each args))
        case .singleton:
          await semaphore.wait()
          defer { semaphore.signal() }
          switch resolution {
          case .instance(let instance):
            return instance
          case .factory:
            let instance = try await resolve(resolver, (repeat each args))
            resolution = .instance(instance)
            return instance
          }
        }
      case .main(let resolve):
        let box = try await MainActor.run {
          let value: Any
          switch lifetime {
          case .transient:
            value = try resolve(resolver, (repeat each args))
          case .singleton:
            switch resolution {
            case .instance(let instance):
              value = instance
            case .factory:
              value = try resolve(resolver, (repeat each args))
              resolution = .instance(value)
            }
          }
          return UncheckedSendableBox(value: value)
        }
        return box.value
      }
    }
  }

  @MainActor
  func resolve<each Arg>(
    with resolver: any Resolver,
    isolation: MainActor,
    args: repeat each Arg
  ) throws -> Any {
    switch resolution {
    case .instance(let instance):
      return instance
    case .factory:
      switch factory {
      case .async:
        throw ResolutionError(key, reason: .requiresAsync)
      case .sync(let resolve):
        switch lifetime {
        case .transient:
          return try resolve(resolver, (repeat each args))
        case .singleton:
          return try lock.sync {
            switch resolution {
            case .instance(let instance):
              return instance
            case .factory:
              let instance = try resolve(resolver, (repeat each args))
              resolution = .instance(instance)
              return instance
            }
          }
        }
      case .main(let resolve):
        let value = try resolve(resolver, (repeat each args))
        switch lifetime {
        case .transient:
          break
        case .singleton:
          resolution = .instance(value)
        }
        return value
      }
    }
  }

  private func resolveSync<each Arg: Sendable>(
    with resolver: any Resolver,
    args: repeat each Arg
  ) throws -> Any {
    switch resolution {
    case .instance(let instance):
      return instance
    case .factory:
      switch factory {
      case .async:
        throw ResolutionError(key, reason: .requiresAsync)
      case .sync(let resolve):
        switch lifetime {
        case .transient:
          return try resolve(resolver, (repeat each args))
        case .singleton:
          return try lock.sync {
            switch resolution {
            case .instance(let instance):
              return instance
            case .factory:
              let instance = try resolve(resolver, (repeat each args))
              resolution = .instance(instance)
              return instance
            }
          }
        }
      case .main:
        throw ResolutionError(key, reason: .requiresMainActor)
      }
    }
  }
}

// swiftlint:enable cyclomatic_complexity
