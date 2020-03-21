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
  private var registrations: Entries = [:]
  
  public init() {}

  public func read() -> Entries {
    lock.read { registrations  }
  }
  
  public func write(_ transform: (Entries) -> Entries) {
    lock.write { registrations = transform(registrations) }
  }
  
  public subscript(key: Key) -> Any? {
    get { lock.read { registrations[key] } }
    set { lock.write { registrations[key] = newValue } }
  }
}
