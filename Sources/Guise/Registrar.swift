//
//  Registrar.swift
//  Guise
//
//  Created by Gregory Higley on 2024-11-06.
//

public protocol Registrar: AnyObject {
  /**
   Gets or sets an `Entry` based on a `Key<T>`.
   
   Direct use of this subscript is discouraged, since
   `Entry` is an opaque type whose methods are not
   visible outside of this module.
   
   Instead, use the various overloads of `register`.
   */
  subscript<T>(key: Key<T>) -> Entry? { get set }
  /// Register a dependent assembly
  func register<each A: Assembly>(assemblies: repeat each A)
}

public extension Registrar {
  @discardableResult
  func register<T, each Arg: Sendable>(
    key: Key<T>,
    lifetime: Lifetime = .transient,
    factory: @escaping @Sendable (any Resolver, repeat each Arg) throws -> T
  ) -> Key<T> {
    self[key] = Entry(key: key, lifetime: lifetime, factory: factory)
    return key
  }

  @discardableResult
  func register<T, each Arg: Sendable>(
    key: Key<T>,
    lifetime: Lifetime = .transient,
    factory: @escaping @Sendable (any Resolver, repeat each Arg) async throws -> T
  ) -> Key<T> {
    self[key] = Entry(key: key, lifetime: lifetime, factory: factory)
    return key
  }

  @discardableResult
  func register<T, each Arg: Sendable>(
    key: Key<T>,
    isolation: MainActor,
    lifetime: Lifetime = .transient,
    factory: @escaping @MainActor @Sendable (any Resolver, repeat each Arg) throws -> T
  ) -> Key<T> {
    self[key] = Entry(key: key, lifetime: lifetime, isolation: isolation, factory: factory)
    return key
  }

  @discardableResult
  func register<T, each Tag: Hashable & Sendable, each Arg: Sendable>(
    _ type: T.Type = T.self,
    tags: repeat each Tag,
    lifetime: Lifetime = .transient,
    factory: @escaping @Sendable (any Resolver, repeat each Arg) throws -> T
  ) -> Key<T> {
    let key = Key<T>(tags: repeat each tags)
    return register(key: key, lifetime: lifetime, factory: factory)
  }

  @discardableResult
  func register<T, each Tag: Hashable & Sendable, each Arg: Sendable>(
    _ type: T.Type = T.self,
    tags: repeat each Tag,
    lifetime: Lifetime = .transient,
    factory: @escaping @Sendable (any Resolver, repeat each Arg) async throws -> T
  ) -> Key<T> {
    let key = Key<T>(tags: repeat each tags)
    return register(key: key, lifetime: lifetime, factory: factory)
  }

  @discardableResult
  func register<T, each Tag: Hashable & Sendable, each Arg: Sendable>(
    _ type: T.Type = T.self,
    tags: repeat each Tag,
    lifetime: Lifetime = .transient,
    isolation: MainActor,
    factory: @escaping @MainActor @Sendable (any Resolver, repeat each Arg) throws -> T
  ) -> Key<T> {
    let key = Key<T>(tags: repeat each tags)
    return register(key: key, isolation: isolation, lifetime: lifetime, factory: factory)
  }

  @discardableResult
  func register<T, each Tag: Hashable & Sendable>(
    _ type: T.Type = T.self,
    tags: repeat each Tag,
    lifetime: Lifetime = .transient,
    instance: @escaping @Sendable @autoclosure () -> T
  ) -> Key<T> {
    let key = Key<T>(tags: repeat each tags)
    return register(key: key, lifetime: lifetime) { _ in instance() }
  }

  @discardableResult
  func register<T, each Tag: Hashable & Sendable>(
    _ type: T.Type = T.self,
    isolation: MainActor,
    tags: repeat each Tag,
    lifetime: Lifetime = .transient,
    instance: @escaping @Sendable @MainActor @autoclosure () -> T
  ) -> Key<T> {
    let key = Key<T>(tags: repeat each tags)
    return register(key: key, isolation: isolation, lifetime: lifetime) { _ in instance() }
  }
}
