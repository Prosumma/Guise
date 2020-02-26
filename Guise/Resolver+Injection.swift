//
//  Resolver+Injection.swift
//  Guise
//
//  Created by Gregory Higley on 2/26/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolver {
  func resolve<Target: AnyObject>(into target: Target, args: [Key: Any] = [:]) {
    let key = Key(Target.self, in: .injection)
    guard let injection = self[key] as? Injection else {
      return
    }
    injection.inject(into: target, resolver: self, args: args)
  }
}
