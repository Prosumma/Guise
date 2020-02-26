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

