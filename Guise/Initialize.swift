//
//  Initialize.swift
//  Guise
//
//  Created by Gregory Higley on 3/2/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public func initialize<Type, Arg>(_ initialize: @escaping (Arg) -> Type) -> (Resolver, Arg) -> Type {
  return { _, arg in initialize(arg) }
}

public func initalize<Type, Arg1, Arg2>(_ initialize: @escaping (Arg1, Arg2) -> Type) -> (Resolver, (Arg1, Arg2)) -> Type {
  return { _, arg in initialize(arg.0, arg.1) }
}

public func initialize<Type, Arg1, Arg2, Arg3>(_ initialize: @escaping (Arg1, Arg2, Arg3) -> Type) -> (Resolver, (Arg1, Arg2, Arg3)) -> Type {
  return { _, arg in initialize(arg.0, arg.1, arg.2) }
}

