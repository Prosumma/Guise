//
//  Singleton.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public final class Singleton: RegistrationBase, LifetimeRegistration {
  private let lock = Lock()
  private let resolution: (Resolver, Any) -> Any
  private var value: Any?

  public init<Type, Arg>(resolve: @escaping (Resolver, Arg) -> Type, metadata: Any) {
    self.resolution = { r, arg in
      resolve(r, arg as! Arg)
    }
    super.init(metadata: metadata)
  }

  public override func resolve<Type, Arg>(resolver: Resolver, type: Type.Type = Type.self, arg: Arg) -> Type? {
    if value == nil {
      lock.write { [unowned self] in
        if self.value == nil {
          self.value = self.resolution(resolver, arg)
        }
      }
    }
    return (value! as! Type)
  }
}
