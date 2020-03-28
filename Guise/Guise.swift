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
open class Guise: Container {
  private let lock = Lock()
  private var registrations: Registrations = [:]
  
  public init() {}
  
  public func makeIterator() -> AnyIterator<Registration> {
    let regs = lock.read { Array(registrations) }
    return AnyIterator(regs.makeIterator())
  }
  
  public func write(_ transform: (Registrations) -> Registrations) {
    lock.write { registrations = transform(registrations) }
  }
  
  public subscript(key: Key) -> Any? {
    get { lock.read { registrations[key] } }
    set { lock.write { registrations[key] = newValue } }
  }
  
  open var builder: FactoryBuilder {
    return FactoryBuilder(registrar: self)
  }
}
