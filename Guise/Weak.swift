//
//  Weak.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public final class Weak: RegistrationBase, LifetimeRegistration {
  private let lock = Lock()
  private var resolution: ((Resolver, Any) -> Any)?
  private weak var value: AnyObject?

  public init<Type, Arg>(resolve: @escaping (Resolver, Arg) -> Type, metadata: Any) {
    self.resolution = { r, arg in
      resolve(r, arg as! Arg)
    }
    super.init(metadata: metadata)
  }
  
  public init(value: Any, metadata: Any) {
    self.resolution = nil
    self.value = value as AnyObject
    super.init(metadata: metadata)
  }

  public override func resolve<Type, Arg>(resolver: Resolver, type: Type.Type, arg: Arg) -> Type? {
    if resolution != nil {
      lock.write { [unowned self] in
        if self.resolution == nil { return }
        defer { self.resolution = nil }
        value = resolution!(resolver, arg) as AnyObject
      }
    }
    if let value = value {
      return (value as! Type)
    }
    return nil
  }
}
