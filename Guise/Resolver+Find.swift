//
//  Resolver+Find.swift
//  Guise
//
//  Created by Gregory Higley on 3/2/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolver {
  /**
   Recursively finds an entry in the resolver, successively
   trying parent scopes until the entry is found. If none
   is found, `nil` is returned.
   */
  func find<Type>(type: Type.Type, in scope: Scope) -> Any? {
    if let value = self[scope / type] {
      return value
    }
    if let parent = scope.parent {
      return find(type: type, in: parent)
    }
    return nil
  }
}
