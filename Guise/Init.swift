//
//  Init.swift
//  Guise
//
//  Created by Gregory Higley on 3/2/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public func init0<Type>(_ initialize: @escaping () -> Type) -> Resolve<Void, Type> {
  return { _, _ in initialize() }
}

public func init1<Type, Arg>(_ initialize: @escaping (Arg) -> Type) -> Resolve<Arg, Type> {
  return { _, arg in initialize(arg) }
}

public func init2<Type, Arg1, Arg2>(_ initialize: @escaping (Arg1, Arg2) -> Type) -> Resolve<(Arg1, Arg2), Type> {
  return { _, arg in initialize(arg.0, arg.1) }
}

public func init3<Type, Arg1, Arg2, Arg3>(_ initialize: @escaping (Arg1, Arg2, Arg3) -> Type) -> Resolve<(Arg1, Arg2, Arg3), Type> {
  return { _, arg in initialize(arg.0, arg.1, arg.2) }
}

