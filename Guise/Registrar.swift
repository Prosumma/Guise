//
//  Registrar.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public protocol Registrar: class {
  /**
   Get or set entries in the registrar.
   
   Conforming implementations are thread-safe.
   */
  subscript(key: Key) -> Any? { get set }
  
  /**
   Transform all entries in the registrar.
   
   Conforming implementations are thread-safe.
   */
  func write(_ transform: (Entries) -> Entries)
}
