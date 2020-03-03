//
//  Init.swift
//  Guise
//
//  Created by Gregory Higley on 3/2/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public func construct<Type, Arg>(_ initialize: @escaping (Arg) -> Type) -> Resolve<Arg, Type> {
  return { _, arg in initialize(arg) }
}

public func construct<Type, Arg1, Arg2>(_ initialize: @escaping (Arg1, Arg2) -> Type) -> Resolve<(Arg1, Arg2), Type> {
  return { _, arg in initialize(arg.0, arg.1) }
}

public func construct<Type, Arg1, Arg2, Arg3>(_ initialize: @escaping (Arg1, Arg2, Arg3) -> Type) -> Resolve<(Arg1, Arg2, Arg3), Type> {
  return { _, arg in initialize(arg.0, arg.1, arg.2) }
}

