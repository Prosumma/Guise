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
  func resolve<Type, Arg>(resolver: Resolver, type: Type.Type, arg: Arg) -> Type?
  func inject(resolver: Resolver, into target: AnyObject, args: [AnyHashable: Any])
}

public extension Registration {
  func inject(resolver: Resolver, into target: AnyObject, args: [AnyHashable: Any] = [:]) {
    NSException(name: .internalInconsistencyException, reason: "Method not implemented", userInfo: nil).raise()
  }

  func resolve<Type>(resolver: Resolver, type: Type.Type = Type.self) -> Type? {
    resolve(resolver: resolver, type: type, arg: ())
  }
  
  func resolve<Type, Arg>(resolver: Resolver, type: Type.Type = Type.self, arg: Arg) -> Type? {
    resolve(resolver: resolver, type: type, arg: arg)
  }
  
  func resolve<Type, Arg1, Arg2>(resolver: Resolver, type: Type.Type = Type.self, arg1: Arg1, arg2: Arg2) -> Type? {
    resolve(resolver: resolver, type: type, arg: (arg1, arg2))
  }
  
  func resolve<Type, Arg1, Arg2, Arg3>(resolver: Resolver, type: Type.Type = Type.self, arg1: Arg1, arg2: Arg2, arg3: Arg3) -> Type? {
    resolve(resolver: resolver, type: type, arg: (arg1, arg2, arg3))
  }
}

