//
//  Resolver.swift
//  Guise
//
//  Created by Gregory Higley on 2024-11-05.
//

public protocol Resolver: AnyObject, Sendable {
  /// Finds any registered keys that match the given `Criteria<T>`.
  func find<T>(_ criteria: Criteria<T>) -> Set<Key<T>>
  /**
   Gets an `Entry` based on a `Key<T>`.
   
   Direct use of this subscript is discouraged, since
   `Entry` is an opaque type whose methods are not
   visible outside of this module.
   
   Instead, use the various overloads of `resolve`.
   */
  subscript<T>(key: Key<T>) -> Entry? { get }
}

public extension Resolver {
  func resolve<T, each Arg: Sendable>(
    key: Key<T>,
    args: repeat each Arg
  ) throws -> T {
    if let type = T.self as? LazyResolving.Type {
      return type.init(tagset: key.tagset, with: self) as! T
    }
    guard let entry = self[key] else {
      switch T.self {
      case let type as ResolutionAdapter.Type:
        return try type.resolve(with: self, key: key, args: repeat each args) as! T
      default:
        throw ResolutionError(key, reason: .notFound)
      }
    }
    return try entry.resolve(with: self, args: repeat each args) as! T
  }

  func resolve<T, each Arg: Sendable>(
    key: Key<T>,
    args: repeat each Arg
  ) async throws -> T {
    if let type = T.self as? LazyResolving.Type {
      return type.init(tagset: key.tagset, with: self) as! T
    }
    guard let entry = self[key] else {
      switch T.self {
      case let type as ResolutionAdapter.Type:
        return try await type.resolve(with: self, key: key, args: repeat each args) as! T
      default:
        throw ResolutionError(key, reason: .notFound)
      }
    }
    return try await entry.resolve(with: self, args: repeat each args) as! T
  }

  @MainActor
  func resolve<T, each Arg: Sendable>(
    key: Key<T>,
    isolation: MainActor,
    args: repeat each Arg
  ) throws -> T {
    if let type = T.self as? LazyResolving.Type {
      return type.init(tagset: key.tagset, with: self) as! T
    }
    guard let entry = self[key] else {
      switch T.self {
      case let type as ResolutionAdapter.Type:
        return try type.resolve(with: self, key: key, isolation: isolation, args: repeat each args) as! T
      default:
        throw ResolutionError(key, reason: .notFound)
      }
    }
    return try entry.resolve(with: self, isolation: isolation, args: repeat each args) as! T
  }

  func resolve<T, each Tag: Hashable & Sendable, each Arg: Sendable>(
    _ type: T.Type = T.self,
    tags: repeat each Tag,
    args: repeat each Arg
  ) throws -> T {
    let key = Key<T>(tags: repeat each tags)
    return try resolve(key: key, args: repeat each args)
  }

  func resolve<T, each Tag: Hashable & Sendable, each Arg: Sendable>(
    _ type: T.Type = T.self,
    tags: repeat each Tag,
    args: repeat each Arg
  ) async throws -> T {
    let key = Key<T>(tags: repeat each tags)
    return try await resolve(key: key, args: repeat each args)
  }

  @MainActor
  func resolve<T, each Tag: Hashable & Sendable, each Arg: Sendable>(
    _ type: T.Type = T.self,
    isolation: MainActor,
    tags: repeat each Tag,
    args: repeat each Arg
  ) throws -> T {
    let key = Key<T>(tags: repeat each tags)
    return try resolve(key: key, isolation: isolation, args: repeat each args)
  }
}
