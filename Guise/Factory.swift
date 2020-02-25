//
//  Factory.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public class Factory: Registration {
  private let resolution: (Resolver, Any) -> Any
  public let metadata: Any

  init<Type, Arg>(resolve: @escaping (Resolver, Arg) -> Type, metadata: Any) {
    self.resolution = { r, arg in
      resolve(r, arg as! Arg)
    }
    self.metadata = metadata
  }

  public func resolve<Type, Arg>(resolver: Resolver, type: Type.Type = Type.self, arg: Arg) -> Type {
    (resolution(resolver, arg) as! Type)
  }
}
