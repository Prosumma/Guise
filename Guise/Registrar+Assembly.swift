//
//  Registrar+Assembly.swift
//  Guise
//
//  Created by Gregory Higley on 3/3/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public extension Registrar where Self: Resolver {
  func register<A: Assembly>(assembly: A) {
    let key: Key = .assemblies / A.self
    if self[key] != nil { return }
    assembly.register(in: self)
    self[key] = 1 // Any value will do.
    assembly.registered(to: self)
  }
}
