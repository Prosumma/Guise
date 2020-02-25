//
//  Registrar.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public protocol Registrar: class {
  subscript(key: Key) -> Registration? { get set }
}

public extension Registrar {
  func register<Type>(type: Type.Type = Type.self, scope: Scope = .root, registration: @escaping @autoclosure () -> Registration) -> (key: Key, registration: Registration) {
    let key = Key(type: type, scope: scope)
    let reg = registration()
    self[key] = reg
    return (key, reg)
  }
}

