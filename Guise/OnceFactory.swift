//
//  OnceFactory.swift
//  Guise
//
//  Created by Gregory Higley on 3/28/20.
//

import Foundation

public final class OnceFactory: LifetimeRegistration {
  public let metadata: Any
  private let lock = Lock()
  private var _factory: Resolve<Any, Any>? = nil
  
  public init<Type, Arg>(type: Type.Type, factory: @escaping Resolve<Arg, Type>, metadata: Any = ()) {
    self._factory = { r, arg in
      factory(r, arg as! Arg)
    }
    self.metadata = metadata
  }
    
  public func resolve<Type, Arg>(type: Type.Type = Type.self, resolver: Resolver, arg: Arg) -> Type? {
    if _factory == nil {
      return nil
    }
    return lock.write {
      guard let factory = _factory else {
        return nil
      }
      let value = factory(resolver, arg) as! Type
      _factory = nil
      return value
    }
  }
}
