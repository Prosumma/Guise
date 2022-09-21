//
//  Assembler.swift
//  Guise
//
//  Created by Greg Higley on 2022-09-21.
//

import Foundation

public protocol Assembler {
  func assemble()
}

public extension Assembler where Self: Registrar {
  func assemble(_ assembly: some Assembly) {
    register(assembly: assembly)
    assemble()
  }
}
