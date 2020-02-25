//
//  Resolver.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public typealias RegistrationEntry = (key: Key, value: Registration)

public protocol Resolver {
  subscript(key: Key) -> Registration? { get }
  func filter(where predicate: (RegistrationEntry) -> Bool) -> [RegistrationEntry]
}

public extension Resolver {
  func find(_ key: Key) -> Registration? {
    if let registration = self[key] {
      return registration
    }
    if let key = key.parent {
      return find(key)
    }
    return nil
  }

  func find<Type>(type: Type.Type, scope: Scope) -> Registration? {
    find(Key(type: type, scope: scope))
  }

  func filter(type: String? = nil, in scope: Scope = .root, metafilter: ((Any) -> Bool)? = nil) -> [RegistrationEntry] {
    return []
  }

  func resolve<Type, Arg>(type: Type.Type = Type.self, scope: Scope = .root, arg: Arg) -> Type? {
    find(type: type, scope: scope)?.resolve(type: type, arg: arg)
  }

  func resolve<Type, Arg1, Arg2>(type: Type.Type = Type.self, scope: Scope = .root, arg1: Arg1, arg2: Arg2) -> Type? {
    resolve(type: type, scope: scope, arg: (arg1, arg2))
  }
}
