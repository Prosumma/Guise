//
//  Resolver+Auto.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolver {
  func auto<Type, Arg>(_ initializer: (Arg) -> Type) -> Type {
    return initializer(resolve()!)
  }
  
  func auto<Type, Arg1, Arg2>(_ initializer: (Arg1, Arg2) -> Type) -> Type {
    return initializer(resolve()!, resolve()!)
  }
}
