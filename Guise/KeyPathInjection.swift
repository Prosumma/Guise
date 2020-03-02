//
//  KeyPathInjection.swift
//  Guise
//
//  Created by Gregory Higley on 3/2/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public class KeyPathInjection: Injection {
  private let _inject: (Resolver, AnyObject, [Key: Any]) -> Void

  public init<Target: AnyObject>(_ inject: @escaping (Resolver, Target, [Key: Any]) -> Void) {
    _inject = { r, o, args in
      inject(r, o as! Target, args)
    }
  }

  public func resolve<Target: AnyObject>(into target: Target, resolver: Resolver, args: [Key : Any] = [:]) {
    _inject(resolver, target, args)
  }
}
