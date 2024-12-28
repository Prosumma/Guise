//
//  SyncAssembly.swift
//  Guise
//
//  Created by Gregory Higley on 2024-12-25.
//

import Guise

struct SyncAssembly: Assembly {
  func register(in registrar: any Registrar) {
    registrar.register(instance: Thing(x: 55))
    registrar.register(factory: auto(House.init))
    registrar.register(lifetime: .singleton, factory: auto(Ningleton.init))
  }
}
