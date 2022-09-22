//
//  Resolver.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

import Foundation

public protocol Resolver: AnyObject {
  /**
   A `Resolver` is essentially a dictionary of `Entry` instances
   keyed by the `Key` type and looked up by `Criteria`. The
   first step in resolving is to perform this lookup.
 
   - Note: Although this method is public, calling it will do you no good,
   since the all properties and methods of the `Entry` type are
   private or internal.
   */
  func resolve(criteria: Criteria) -> [Key: Entry]
}

extension Resolver {
  func adapt<T>(_ type: T.Type = T.self, criteria: Criteria) -> Criteria {
    switch type {
    case let type as ResolutionAdapter.Type:
      return type.adapt(criteria: criteria, with: self)
    default:
      return criteria
    }
  }
  
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

