//
//  Scope.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public struct Scope: Hashable {
  
  private struct HashedType: Hashable {
    public let name: String
    public init<Type>(_ type: Type.Type) {
      name = String(reflecting: type)
    }
  }
  
  private class Parent {
    let scope: Scope
    init(_ scope: Scope) {
      self.scope = scope
    }
  }
  
  public let identifier: AnyHashable
  private let _parent: Parent?
  
  public init<Identifier: Hashable>(_ identifier: Identifier, in parent: Scope? = nil) {
    if let child = identifier as? Scope {
      if let parent = parent {
        self = parent.adopt(child)
      } else {
        self = child
      }
    } else {
      self.identifier = identifier
      if let parent = parent {
        self._parent = Parent(parent)
      } else {
        self._parent = nil
      }
    }
  }
    
  public init(in parent: Scope? = nil) {
    self.identifier = UUID()
    self._parent = nil
  }
  
  public init<Type>(_ type: Type.Type, in parent: Scope? = nil) {
    self.init(HashedType(type), in: parent)
  }
  
  public var parent: Scope? {
    _parent?.scope
  }
  
  public var bottom: Scope {
    guard let parent = parent else {
      return self
    }
    return parent.bottom
  }
  
  public var length: Int {
    1 + (parent?.length ?? 0)
  }
  
  public func starts(with ancestor: Scope) -> Bool {
    let ancestorLength = ancestor.length
    var descendant = self
    while descendant.length > ancestorLength {
      // It is not possible for parent to be nil in this algorithm.
      descendant = descendant.parent!
    }
    return descendant == ancestor
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
    if let parent = parent {
      hasher.combine(parent)
    }
  }
  
  private func adopt(_ child: Scope) -> Scope {
    func reparent(_ child: Scope) -> Scope {
      if let parent = child.parent {
        return Scope(child.identifier, in: reparent(parent))
      }
      return Scope(child.identifier, in: self)
    }
    return reparent(child)
  }
    
  public static func ==(lhs: Scope, rhs: Scope) -> Bool {
    lhs.identifier == rhs.identifier && lhs.parent == rhs.parent
  }
}

extension Scope: CustomDebugStringConvertible {
  public var debugDescription: String {
    if let parent = parent {
      return "Scope(\(identifier), parent: \(parent))"
    }
    return "Scope(\(identifier))"
  }
}

extension Scope: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.init(value)
  }
}

public func /<R: Hashable>(lhs: Scope, rhs: R) -> Scope {
  Scope(rhs, in: lhs)
}

public func /<Type>(lhs: Scope, rhs: Type.Type) -> Key {
  Scope(rhs, in: lhs)
}
