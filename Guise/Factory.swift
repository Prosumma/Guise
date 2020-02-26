//
//  Factory.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public final class Factory: RegistrationBase, LifetimeRegistration {
  private let resolution: (Resolver, Any) -> Any

  public init<Type, Arg>(resolve: @escaping (Resolver, Arg) -> Type, metadata: Any) {
    self.resolution = { r, arg in
      resolve(r, arg as! Arg)
    }
    super.init(metadata: metadata)
  }

  public override func resolve<Type, Arg>(type: Type.Type, resolver: Resolver, arg: Arg) -> Type? {
    (resolution(resolver, arg) as! Type)
  }
}
