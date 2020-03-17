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
    // If the assembly is already registered,
    // we can short-circuit the whole process.
    if self[key] != nil { return }
    var shouldRegister = false
    // The static subscript of `RegisteredAssembly`
    // always returns a queue bound to the type of `A`.
    RegisteredAssembly[A.self].sync {
      // We must check again. Just because
      // we "acquired" the queue does not
      // mean we were the first to execute.
      if self[key] != nil { return }
      self[key] = RegisteredAssembly()
      shouldRegister = true
    }
    if shouldRegister {
      // Perform the actual registration outside
      // of the queue to prevent deadlocks.
      assembly.register(in: self)
      assembly.registered(to: self)
    }
  }
}
