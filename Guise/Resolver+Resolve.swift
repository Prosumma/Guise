//
//  Resolver+Resolve.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolver {
  func resolve<Type>(type: Type.Type = Type.self, in scope: Scope = .default) -> Type? {
    return resolve(type: type, in: scope, arg: ())
  }
  
  func resolve<Type, Arg>(type: Type.Type = Type.self, in scope: Scope = .default, arg: Arg) -> Type? {
    guard let registration = find(type: type, in: scope) as? Registration else { return nil }
    return registration.resolve(type: type, resolver: self, arg: arg)
  }
  
  func resolve<Type, Arg1, Arg2>(type: Type.Type = Type.self, in scope: Scope = .default, arg1: Arg1, arg2: Arg2) -> Type? {
    return resolve(type: type, in: scope, arg: (arg1, arg2))
  }
  
  func resolve<Type, Arg1, Arg2, Arg3>(type: Type.Type = Type.self, in scope: Scope = .default, arg1: Arg1, arg2: Arg2, arg3: Arg3) -> Type? {
    return resolve(type: type, in: scope, arg: (arg1, arg2, arg3))
  }
}

