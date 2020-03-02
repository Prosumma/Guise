//
//  Registrar.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public protocol Registrar: class {
  subscript(key: Key) -> Any? { get set }
  func rewrite(_ write: @escaping (Registrations) -> Registrations)
}
