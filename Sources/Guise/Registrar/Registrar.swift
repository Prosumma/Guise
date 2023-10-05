//
//  Registrar.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

public protocol Registrar {
  @discardableResult
  func register<T, each A>(
    _ type: T.Type,
    tags: Set<AnyHashable>,
    lifetime: Lifetime,
    factory: @escaping SyncFactory<T, repeat each A>
  ) -> Key
  @discardableResult
  func register<T, each A>(
    _ type: T.Type,
    tags: Set<AnyHashable>,
    lifetime: Lifetime,
    factory: @escaping AsyncFactory<T, repeat each A>
  ) -> Key
  func unregister(keys: Set<Key>)
}

public extension Registrar {
  func unregister(keys: Key...) {
    unregister(keys: Set(keys))
  }
}

public extension Registrar where Self: Resolver {
  func unregister(criteria: Criteria) {
    unregister(keys: Set(resolve(criteria: criteria).keys))
  }
}
