//
//  Lifetime.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public enum Lifetime {
  case transient
  case singleton
  case weak
  
  public var registrationType: LifetimeRegistration.Type {
    switch self {
    case .transient: return TransientRegistration.self
    case .singleton: return SingletonRegistration.self
    case .weak: return WeakRegistration.self
    }
  }
  
  public func register<Type, Arg>(type: Type.Type, factory: @escaping Resolve<Arg, Type>, metadata: Any) -> Registration {
    return self.registrationType.init(type: type, factory: factory, metadata: metadata)
  }
}

public protocol LifetimeRegistration: Registration {
  init<Type, Arg>(type: Type.Type, factory: @escaping (Resolver, Arg) -> Type, metadata: Any)
}

