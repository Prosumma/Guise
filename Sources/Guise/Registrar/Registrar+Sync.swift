//
//  Registrar.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//


public extension Registrar {
  typealias SyncFactory<T, A> = (any Resolver, A) throws -> T

  @discardableResult
  func register<T, A>(
    _ type: T.Type,
    name: Set<AnyHashable>,
    lifetime: Lifetime,
    factory: @escaping SyncFactory<T, A>
  ) -> Key {
    let key = Key(type, name: name, args: A.self)
    let entry = Entry(lifetime: lifetime, factory: factory)
    register(key: key, entry: entry)
    return key
  }
  
  @discardableResult
  func register<T>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    lifetime: Lifetime = .transient,
    factory: @escaping (any Resolver) throws -> T
  ) -> Key {
    let factory: SyncFactory<T, Void> = { r, _ in
      try factory(r)
    }
    return register(type, name: Set(name), lifetime: lifetime, factory: factory)
  }
  
  @discardableResult
  func register<T, A>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    lifetime: Lifetime = .transient,
    factory: @escaping SyncFactory<T, A>
  ) -> Key {
    register(type, name: Set(name), lifetime: lifetime, factory: factory)
  }
 
  @discardableResult
  func register<T, A1, A2>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    lifetime: Lifetime = .transient,
    factory: @escaping (any Resolver, A1, A2) throws -> T
  ) -> Key {
    let factory: SyncFactory<T, (A1, A2)> = { r, arg in
      try factory(r, arg.0, arg.1)
    }
    return register(type, name: Set(name), lifetime: lifetime, factory: factory)
  }
}

extension Registrar {
  @discardableResult
  func register<T>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    lifetime: Lifetime = .transient,
    service: @escaping @autoclosure () -> T
  ) -> Key {
    let factory: SyncFactory<T, Void> = { _, _ in
      service()
    }
    return register(type, name: Set(name), lifetime: lifetime, factory: factory)
  }
}
