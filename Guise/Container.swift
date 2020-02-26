//
//  Container.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public class Container: Registrar & Resolver {
  private let lock = Lock()
  private var registrations: [Key: Registration] = [:]

  public subscript(key: Key) -> Registration? {
    get { lock.read { registrations[key] }}
    set { lock.write { registrations[key] = newValue }}
  }

  public func filter(where predicate: (RegistrationEntry) -> Bool) -> [RegistrationEntry] {
    lock.read { registrations.filter(predicate) }
  }
}

public var Guise: Registrar & Resolver = Container()
