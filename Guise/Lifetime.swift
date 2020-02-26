//
//  Lifetime.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public enum Lifetime {
  case factory
  case singleton
  case weak
  
  public var registrationType: LifetimeRegistration.Type {
    switch self {
    case .factory: return Factory.self
    case .singleton: return Singleton.self
    case .weak: return Weak.self
    }
  }
}

public protocol LifetimeRegistration: Registration {
  init<Type, Arg>(resolve: @escaping (Resolver, Arg) -> Type, metadata: Any)
}
