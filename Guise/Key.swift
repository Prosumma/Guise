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

  public init(_ type: String, in scope: Scope = .default) {
    self.type = type
    self.scope = scope
  }

  public init<Type>(_ type: Type.Type, in scope: Scope = .default) {
    self.init(String(reflecting: type), in: scope)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(type)
    scope.hash(into: &hasher)
  }

  public var parent: Key? {
    if let parent = scope.parent {
      return Key(type, in: parent)
    }
    return nil
  }
  
  public func starts(with prefix: Scope) -> Bool {
    scope.starts(with: prefix)
  }
}
