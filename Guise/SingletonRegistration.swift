//
//  SingletonRegistration.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public final class SingletonRegistration: LifetimeFactory {
  public let metadata: Any
  private let lock = Lock()
  private let _factory: Resolve<Any, Any>
  private var value: Any?
  
  public init<Type, Arg>(type: Type.Type, factory: @escaping Resolve<Arg, Type>, metadata: Any = ()) {
    self._factory = { r, arg in factory(r, arg as! Arg) }
    self.metadata = metadata
  }
  
  public func resolve<Type, Arg>(type: Type.Type = Type.self, resolver: Resolver, arg: Arg) -> Type? {
    if let value = value {
      return (value as! Type)
    }
    return lock.write {
      if let value = self.value {
        return (value as! Type)
      }
      let resolved = (self._factory(resolver, arg) as! Type)
      self.value = resolved
      return resolved
    }
  }
}
