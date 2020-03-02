//
//  Resolver+Injection.swift
//  Guise
//
//  Created by Gregory Higley on 3/2/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolver {
  func resolve<Target: AnyObject>(into target: Target, type: Target.Type = Target.self, args: [Key: Any] = [:]) {
    let key = Scope.injections / type
    guard let injection = self[key] as? Injection else { return }
    injection.resolve(into: target, resolver: self, args: args)
  }
}
