//
//  Registrar.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

import Foundation

public typealias SyncFactory<T, A> = (any Resolver, A) throws -> T
public typealias AsyncFactory<T, A> = (any Resolver, A) async throws -> T

public protocol Registrar {
  func register(key: Key, entry: Entry)
  func unregister(keys: Set<Key>)
  func register<A: Assembly>(assembly: A)
}

public extension Registrar {
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

public extension Registrar {
  @discardableResult
  func register<T, A>(
    _ type: T.Type,
    name: Set<AnyHashable>,
    lifetime: Lifetime,
    factory: @escaping AsyncFactory<T, A>
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
    factory: @escaping (any Resolver) async throws -> T
  ) -> Key {
    let factory: (any Resolver, Void) async throws -> T = { r, _ in
      try await factory(r)
    }
    return register(type, name: Set(name), lifetime: lifetime, factory: factory)
  }
  
  @discardableResult
  func register<T, A>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    lifetime: Lifetime = .transient,
    factory: @escaping AsyncFactory<T, A>
  ) -> Key {
    register(type, name: Set(name), lifetime: lifetime, factory: factory)
  }
  
  @discardableResult
  func register<T, A1, A2>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    lifetime: Lifetime = .transient,
    factory: @escaping (any Resolver, A1, A2) async throws -> T
  ) -> Key {
    let factory: AsyncFactory<T, (A1, A2)> = { r, arg in
      try await factory(r, arg.0, arg.1)
    }
    return register(type, name: Set(name), lifetime: lifetime, factory: factory)
  }
}
