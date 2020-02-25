//
//  Key.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public struct Key: Hashable {
  public let type: String
  public let scope: Scope

  public init(type: String, scope: Scope) {
    self.type = type
    self.scope = scope
  }

  public init<Type>(type: Type.Type, scope: Scope) {
    self.init(type: String(reflecting: type), scope: scope)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(type)
    scope.hash(into: &hasher)
  }

  public var parent: Key? {
    if let parent = scope.parent {
      return Key(type: type, scope: parent)
    }
    return nil
  }
}
