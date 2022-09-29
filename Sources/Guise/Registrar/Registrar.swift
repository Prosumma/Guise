//
//  Registrar.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

import Foundation

public protocol Registrar {
  // MARK: Entries
  func register(key: Key, entry: Entry)
  func unregister(keys: Set<Key>)

  // MARK: Assemblies
  func register<A: Assembly>(assembly: A)
}

public extension Registrar {
  func unregister(keys: Key...) {
    unregister(keys: Set(keys))
  }
}

public extension Registrar where Self: Resolver {
  func unregister(criteria: Criteria) {
    unregister(keys: Set(resolve(criteria: criteria).keys))
  }
}
