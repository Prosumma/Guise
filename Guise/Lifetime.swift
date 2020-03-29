//
//  Lifetime.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public struct Lifetime {
  private let factoryType: LifetimeRegistration.Type
  private let state: Any
  
  public init<FactoryType: LifetimeRegistration>(_ type: FactoryType.Type, state: Any = ()) {
    self.factoryType = type
    self.state = state
  }
  
  public func register<Type, Arg>(type: Type.Type, factory: @escaping Resolve<Arg, Type>, metadata: Any) -> FactoryRegistration {
    return factoryType.init(type: type, factory: factory, metadata: metadata, state: state)
  }
}

public extension Lifetime {
  static let transient = Lifetime(TransientFactory.self)
  static let singleton = Lifetime(SingletonFactory.self)
  static let `weak` = Lifetime(WeakFactory.self)
  static let once = Lifetime(OnceFactory.self)
}

public protocol LifetimeRegistration: FactoryRegistration {
  init<Type, Arg>(type: Type.Type, factory: @escaping (Resolver, Arg) -> Type, metadata: Any, state: Any)
}

