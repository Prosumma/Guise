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
   */
  func resolve(criteria: Criteria) -> [Key: any Resolvable]
}

extension Resolver {
  func resolve(key: Key) throws -> Entry {
    let criteria = Criteria(key: key)
    let entries = resolve(criteria: criteria)
    let result: Entry
    if let entry = entries[key] as? Entry {
      result = entry
    } else {
      throw ResolutionError(key: key, reason: .notFound)
    }
    return result
  }
}
