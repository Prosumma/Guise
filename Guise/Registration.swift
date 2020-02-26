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
}

public extension Registration {
  func resolve<Type, Arg>(resolver: Resolver, type: Type.Type = Type.self, arg: Arg) -> Type? {
    resolve(resolver: resolver, type: type, arg: arg)
  }
}
