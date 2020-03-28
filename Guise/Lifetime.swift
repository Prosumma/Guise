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
  
  public var factoryType: LifetimeRegistration.Type {
    switch self {
    case .transient: return TransientFactory.self
    case .singleton: return SingletonFactory.self
    case .weak: return WeakFactory.self
    }
  }
  
  public func register<Type, Arg>(type: Type.Type, factory: @escaping Resolve<Arg, Type>, metadata: Any) -> FactoryRegistration {
    return self.factoryType.init(type: type, factory: factory, metadata: metadata)
  }
}

public protocol LifetimeRegistration: FactoryRegistration {
  init<Type, Arg>(type: Type.Type, factory: @escaping (Resolver, Arg) -> Type, metadata: Any)
}

