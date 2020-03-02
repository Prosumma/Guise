//
//  Resolver.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public typealias Registrations = [Key: Any]

public protocol Resolver {
  subscript(key: Key) -> Any? { get }
  func filter(_ isIncluded: (Registrations.Element) -> Bool) -> Registrations
}

public extension Resolver {
  func find(_ key: Key) -> Any? {
    if let value = self[key] {
      return value
    }
    if let parent = key.parent {
      return find(parent)
    }
    return nil
  }
}
