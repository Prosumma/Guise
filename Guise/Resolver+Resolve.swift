//
//  Resolver+Resolve.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolver {
  func resolve<Type, Arg>(type: Type.Type = Type.self, scope: Scope = .root, arg: Arg) -> Type? {
    find(type: type, scope: scope)?.resolve(resolver: self, type: type, arg: arg)
  }

  func resolve<Type, Arg1, Arg2>(type: Type.Type = Type.self, scope: Scope = .root, arg1: Arg1, arg2: Arg2) -> Type? {
    resolve(type: type, scope: scope, arg: (arg1, arg2))
  }
  
  func resolve<Type>(type: Type.Type = Type.self, scope: Scope = .root) -> Type? {
    resolve(type: type, scope: scope, arg: ())
  }
}
