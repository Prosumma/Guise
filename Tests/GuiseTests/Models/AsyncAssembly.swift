//
//  AsyncAssembly.swift
//  Guise
//
//  Created by Gregory Higley on 2024-12-25.
//

import Guise

struct AsyncAssembly: Assembly {
  func register(in registrar: any Registrar) {
    registrar.register { _ in
      await Alien(s: "Xenomorph")
    }
    registrar.register(factory: auto(Spaceship.init))
    registrar.register(lifetime: .singleton, factory: auto(Singleton.init))
  }
}
