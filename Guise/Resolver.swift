//
//  Resolver.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public protocol Resolver {
  subscript(key: Key) -> Registration? { get }
}

public extension Resolver {
  func find(_ key: Key) -> Registration? {
    if let registration = self[key] {
      return registration
    }
    if let key = key.parent {
      return find(key)
    }
    return nil
  }
}
