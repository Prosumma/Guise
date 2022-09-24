//
//  Assembler.swift
//  Guise
//
//  Created by Greg Higley on 2022-09-21.
//

import Foundation

public protocol Assembler {
  func assemble() throws
}

public extension Assembler where Self: Registrar {
  func assemble(_ assembly: some Assembly) throws {
    register(assembly: assembly)
    try assemble()
  }
}
