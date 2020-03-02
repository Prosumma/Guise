//
//  WeakRegistration.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public final class WeakRegistration: LifetimeRegistration {
  public init<Type, Arg>(type: Type.Type, factory: @escaping (Resolver, Arg) -> Type) {
    
  }
  
  public func resolve<Type, Arg>(type: Type.Type = Type.self, resolver: Resolver, arg: Arg) -> Type? {
    return nil
  }
}
