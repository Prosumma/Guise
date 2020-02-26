//
//  Registration.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public protocol Registration {
  var metadata: Any { get }
  func resolve<Type, Arg>(type: Type.Type, resolver: Resolver, arg: Arg) -> Type?
  func inject(resolver: Resolver, into target: AnyObject, args: [Key: Any])
}

public extension Registration {
  func inject(resolver: Resolver, into target: AnyObject, args: [Key: Any] = [:]) {
    NSException(name: .internalInconsistencyException, reason: "Method not implemented", userInfo: nil).raise()
  }

  func resolve<Type>(type: Type.Type = Type.self, resolver: Resolver) -> Type? {
    resolve(type: type, resolver: resolver, arg: ())
  }
  
  func resolve<Type, Arg>(type: Type.Type = Type.self, resolver: Resolver, arg: Arg) -> Type? {
    resolve(type: type, resolver: resolver, arg: arg)
  }
  
  func resolve<Type, Arg1, Arg2>(type: Type.Type = Type.self, resolver: Resolver, arg1: Arg1, arg2: Arg2) -> Type? {
    resolve(type: type, resolver: resolver, arg: (arg1, arg2))
  }
  
  func resolve<Type, Arg1, Arg2, Arg3>(type: Type.Type = Type.self, resolver: Resolver, arg1: Arg1, arg2: Arg2, arg3: Arg3) -> Type? {
    resolve(type: type, resolver: resolver, arg: (arg1, arg2, arg3))
  }
}

