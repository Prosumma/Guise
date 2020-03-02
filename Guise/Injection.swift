//
//  Injection.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public protocol Injection {
  func resolve<Type: AnyObject>(into target: Type, args: [Scope: Any])
}

public extension Injection {
  func resolve<Type: AnyObject>(into target: Type, args: [Scope: Any] = [:]) {
    resolve(into: target, args: args)
  }
}
