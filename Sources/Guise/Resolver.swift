//
//  Resolver.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

import Foundation

public protocol Resolver: AnyObject {
  func resolve(criteria: Criteria) -> [Key: Entry]
}

public extension Resolver {
  func resolve(key: Key) throws -> Entry {
    let criteria = Criteria(key: key)
    let entries = resolve(criteria: criteria)
    if let entry = entries[key] {
      return entry
    } else {
      throw ResolutionError(criteria: criteria, reason: .notFound)
    }
  }
}


