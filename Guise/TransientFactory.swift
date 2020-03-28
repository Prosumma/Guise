//
//  TransientRegistration.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public final class TransientFactory: LifetimeFactory {
  public let metadata: Any
  private let _factory: Resolve<Any, Any>
  
  public init<Type, Arg>(type: Type.Type, factory: @escaping Resolve<Arg, Type>, metadata: Any = ()) {
    self._factory = { r, arg in factory(r, arg as! Arg) }
    self.metadata = metadata
  }
  
  public func resolve<Type, Arg>(type: Type.Type = Type.self, resolver: Resolver, arg: Arg) -> Type? {
    (_factory(resolver, arg) as! Type)
  }
}
