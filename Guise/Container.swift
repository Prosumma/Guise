//
//  Container.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

/**
 The default, thread-safe implementation of `Registrar` and `Resolver`.

 This is all that is needed for all of Guise's functionality to work. Rolling
 your own implementation is simple.
 */
public class Container: Registrar & Resolver {
  private let lock = Lock()
  private var _registrations: Registrations = [:]
  
  public init() {}
  
  public var registrations: Registrations {
    lock.read { _registrations }
  }
  
  public func write(_ setter: (Registrations) -> Registrations) {
    lock.write { _registrations = setter(_registrations) }
  }
  
  public subscript(key: Key) -> Any? {
    get { lock.read { _registrations[key] } }
    set { lock.write { _registrations[key] = newValue } }
  }
}
