//
//  TestAssembly.swift
//  Guise
//
//  Created by Gregory Higley on 2025-12-24.
//

import Guise

struct TestAssembly: Assembly {
  func register(in registrar: any Registrar) {
    registrar.register(assemblies: SyncAssembly(), AsyncAssembly())
  }
}
