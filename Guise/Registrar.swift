//
//  Registrar.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

/**
 A `Registrar` is a type that maps keys (of
 type `Key`) to values (of type `Any`).
 
 In essence, a `Registrar` is simply a thread-
 safe, hierarchical key-value store. It is
 hierarchical because the `Key` type is itself
 hierarchical.
 
 The entire edifice of Guise is built upon
 this simple base.
 */
public protocol Registrar: class, FactoryBuilderProtocol {
  /**
   Get or set entries in the registrar.
   
   Conforming implementations are thread-safe.
   
   The `subscript` is a low-level method
   not intended for direct use. Instead,
   use the various overloads of `register`.
   */
  subscript(key: Key) -> Any? { get set }
  
  /**
   Transform all entries in the registrar.
   
   Conforming implementations are thread-safe.
   */
  func write(_ transform: (Registrations) -> Registrations)
}
