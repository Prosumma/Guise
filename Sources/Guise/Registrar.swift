//
//  Registrar.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

import Foundation

public protocol Registrar {
  func register(key: Key, entry: Entry)
  func unregister(keys: Set<Key>)
}

public extension Registrar {
  @discardableResult
  func register<T, A>(
    _ type: T.Type,
    name: Set<AnyHashable>,
    lifetime: Lifetime,
    factory: @escaping (any Resolver, A) throws -> T
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
    let key = Key(type, name: Set(name), args: Void.self)
    let factory: (any Resolver, Void) throws -> T = { r, _ in
      try factory(r)
    }
    let entry = Entry(lifetime: lifetime, factory: factory)
    register(key: key, entry: entry)
    return key
  }
  
  @discardableResult
  func register<T, A>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    lifetime: Lifetime = .transient,
    factory: @escaping (any Resolver, A) throws -> T
  ) -> Key {
    let key = Key(type, name: Set(name), args: A.self)
    let entry = Entry(lifetime: lifetime, factory: factory)
    register(key: key, entry: entry)
    return key
  }
  
  @discardableResult
  func register<T>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    lifetime: Lifetime = .transient,
    service: @escaping @autoclosure () -> T
  ) -> Key {
    let key = Key(type, name: Set(name), args: Void.self)
    let factory: (any Resolver, Void) throws -> T = { _, _ in
      service()
    }
    let entry = Entry(lifetime: lifetime, factory: factory)
    register(key: key, entry: entry)
    return key
  }
}

public extension Registrar {
  @discardableResult
  func register<T, A>(
    _ type: T.Type,
    name: Set<AnyHashable>,
    lifetime: Lifetime,
    factory: @escaping (any Resolver, A) async throws -> T
  ) -> Key {
    let key = Key(type, name: name, args: A.self)
    let entry = Entry(lifetime: lifetime, factory: factory)
    register(key: key, entry: entry)
    return key
  }
}
