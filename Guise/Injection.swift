//
//  Injection.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public protocol Injection {
  func resolve<Target: AnyObject>(into target: Target, resolver: Resolver, args: [Key: Any])
}

public extension Injection {
  func resolve<Target: AnyObject>(into target: Target, resolver: Resolver, args: [Key: Any] = [:]) {
    resolve(into: target, resolver: resolver, args: args)
  }
}
