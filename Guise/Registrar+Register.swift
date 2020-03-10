//
//  Registrar+Register.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public extension Registrar {
  @discardableResult func register<Type>(type: Type.Type = Type.self, in scope: Scope = .default, lifetime: Lifetime = .transient, metadata: Any = (), factory: @escaping (Resolver) -> Type) -> Key {
    register(type: type, in: scope, lifetime: lifetime, metadata: metadata) { (r: Resolver, _: Void) in
      factory(r)
    }
  }
  
  @discardableResult func register<Type, Arg>(type: Type.Type = Type.self, in scope: Scope = .default, lifetime: Lifetime = .transient, metadata: Any = (), factory: @escaping (Resolver, Arg) -> Type) -> Key {
    let key = scope / type
    self[key] = lifetime.register(type: type, factory: factory, metadata: metadata)
    return key
  }

  @discardableResult func register<Type, Arg1, Arg2>(type: Type.Type = Type.self, in scope: Scope = .default, lifetime: Lifetime = .transient, metadata: Any = (), factory: @escaping (Resolver, Arg1, Arg2) -> Type) -> Key {
    register(type: type, in: scope, lifetime: lifetime, metadata: metadata) { (r: Resolver, arg: (Arg1, Arg2) ) in
      factory(r, arg.0, arg.1)
    }
  }
  
  @discardableResult func register<Type, Arg1, Arg2, Arg3>(type: Type.Type = Type.self, in scope: Scope = .default, lifetime: Lifetime = .transient, metadata: Any = (), factory: @escaping (Resolver, Arg1, Arg2, Arg3) -> Type) -> Key {
    register(type: type, in: scope, lifetime: lifetime, metadata: metadata) { (r: Resolver, arg: (Arg1, Arg2, Arg3) ) in
      factory(r, arg.0, arg.1, arg.2)
    }
  }
  
  @discardableResult func register<Type>(transient: @escaping @autoclosure () -> Type, in scope: Scope = .default, metadata: Any = ()) -> Key {
    register(in: scope, lifetime: .transient, metadata: metadata, factory: construct(transient))
  }
  
  @discardableResult func register<Type>(singleton: @escaping @autoclosure () -> Type, in scope: Scope = .default, metadata: Any = ()) -> Key {
    register(in: scope, lifetime: .singleton, metadata: metadata, factory: construct(singleton))
  }

  @discardableResult func register<Type: AnyObject>(weak weakling: Type, in scope: Scope = .default, metadata: Any = ()) -> Key {
    let key = scope / Type.self
    self[key] = WeakRegistration(weakling, metadata: metadata)
    return key
  }
}
