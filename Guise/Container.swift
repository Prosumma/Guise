//
//  Container.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public class Container: Registrar & Resolver {
  private let lock = Lock()
  private var registrations: Registrations = [:]
  
  public subscript(key: Key) -> Any? {
    get { return lock.read{ registrations[key] } }
    set { lock.write{ registrations[key] = newValue } }
  }
  
  public func filter(_ isIncluded: (Registrations.Element) -> Bool) -> Registrations {
    return lock.read{ registrations.filter(isIncluded) }
  }
  
  public func rewrite(_ write: @escaping (Registrations) -> Registrations) {
    lock.write { self.registrations = write(self.registrations) }
  }
}
