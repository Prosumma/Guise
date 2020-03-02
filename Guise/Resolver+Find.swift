//
//  Resolver+Find.swift
//  Guise
//
//  Created by Gregory Higley on 3/2/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolver {
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
