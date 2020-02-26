//
//  Registrar+Register.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public extension Registrar {
  
  @discardableResult func register<Type, Arg>(type: Type.Type = Type.self, scope: Scope = .default, lifetime: Lifetime = .factory, metadata: Any = (), resolve: @escaping (Resolver, Arg) -> Type) -> Key {
    let key = Key(type: type, scope: scope)
    self[key] = lifetime.registrationType.init(resolve: resolve, metadata: metadata)
    return key
  }
  
  @discardableResult func register<Type>(type: Type.Type = Type.self, scope: Scope = .default, lifetime: Lifetime = .factory, metadata: Any = (), resolve: @escaping (Resolver) -> Type) -> Key {
    register(type: type, scope: scope, lifetime: lifetime, metadata: metadata) { (r: Resolver, _: Void) in
      resolve(r)
    }
  }
  
  @discardableResult func register<Type, Arg1, Arg2>(type: Type.Type = Type.self, scope: Scope = .default, lifetime: Lifetime = .factory, metadata: Any = (), resolve: @escaping (Resolver, Arg1, Arg2) -> Type) -> Key {
    register(type: type, scope: scope, lifetime: lifetime, metadata: metadata) { (r: Resolver, arg: (Arg1, Arg2)) in
      resolve(r, arg.0, arg.1)
    }
  }
  
  @discardableResult func register<Type>(factory: @escaping @autoclosure () -> Type, scope: Scope = .default, metadata: Any = ()) -> Key {
    register(type: Type.self, scope: scope, lifetime: .factory, metadata: metadata) { _ in
      factory()
    }
  }
  
  @discardableResult func register<Type>(singleton: @escaping @autoclosure () -> Type, scope: Scope = .default, metadata: Any = ()) -> Key {
    register(type: Type.self, scope: scope, lifetime: .singleton, metadata: metadata) { _ in
      singleton()
    }
  }
  
  @discardableResult func register<Type: AnyObject>(weak weakling: Type, scope: Scope = .default, metadata: Any = ()) -> Key {
    let key = Key(type: Type.self, scope: scope)
    self[key] = Weak(value: weakling, metadata: metadata)
    return key
  }
}

