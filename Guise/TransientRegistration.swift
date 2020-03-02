//
//  TransientRegistration.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public final class TransientRegistration: LifetimeRegistration {
  private let _factory: (Resolver, Any) -> Any
  
  public init<Type, Arg>(type: Type.Type, factory: @escaping (Resolver, Arg) -> Type) {
    _factory = { r, arg in factory(r, arg as! Arg) }
  }
  
  public func resolve<Type, Arg>(type: Type.Type = Type.self, resolver: Resolver, arg: Arg) -> Type? {
    (_factory(resolver, arg) as! Type)
  }
}
