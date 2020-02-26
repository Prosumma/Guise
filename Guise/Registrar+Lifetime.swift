//
//  Registrar+Register.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public extension Registrar {
  
  @discardableResult func register<Type>(factory: @escaping @autoclosure () -> Type, in scope: Scope = .default, metadata: Any = ()) -> Key {
    register(type: Type.self, in: scope, lifetime: .factory, metadata: metadata) { _ in
      factory()
    }
  }
  
  @discardableResult func register<Type>(singleton: @escaping @autoclosure () -> Type, in scope: Scope = .default, metadata: Any = ()) -> Key {
    register(type: Type.self, in: scope, lifetime: .singleton, metadata: metadata) { _ in
      singleton()
    }
  }
  
  @discardableResult func register<Type: AnyObject>(weak weakling: Type, in scope: Scope = .default, metadata: Any = ()) -> Key {
    let key = Key(Type.self, in: scope)
    self[key] = Weak(value: weakling, metadata: metadata)
    return key
  }
}

