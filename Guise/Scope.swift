//
//  Scope.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public struct Scope: Equatable, CustomStringConvertible, CustomDebugStringConvertible {
  private class Parent {
    let scope: Scope
    init(_ scope: Scope) {
      self.scope = scope
    }
  }

  private let _parent: Parent?
  public let identifier: AnyHashable

  private init(identifier: AnyHashable) {
    self._parent = nil
    self.identifier = identifier
  }

  public init(parent: Scope, identifier: AnyHashable = UUID()) {
    self._parent = Parent(parent)
    self.identifier = identifier
  }

  public var parent: Scope? {
    _parent?.scope
  }
  
  public var length: Int {
    (parent?.length ?? 0) + 1
  }
  
  public func starts(with prefix: Scope) -> Bool {
    let prefixLength = prefix.length
    var parent = self
    while parent.length > prefixLength {
      // This is safe because Scope.root always
      // lives at the base of the scope hierarchy.
      parent = parent.parent!
    }
    return parent == prefix
  }
  
  public var description: String {
    let description: String
    if let parent = parent {
      description = "\(parent)/\(identifier)"
    } else {
      description = "\(identifier)"
    }
    return description
  }
  
  public var debugDescription: String {
    "Scope(\(self))"
  }

  /// `Scope` is not `Hashable` but participates in the hashing of `Key`.
  internal func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
    parent?.hash(into: &hasher)
  }

  public static func ==(lhs: Scope, rhs: Scope) -> Bool {
    lhs.identifier == rhs.identifier && lhs.parent == rhs.parent
  }

  public static let root = Scope(identifier: "$root$")
  public static let `default` = Scope.root / "$default$"
  public static let injections = Scope(identifier: "$injections$")
}

public func /<R: Hashable>(lhs: Scope, rhs: R) -> Scope {
  Scope(parent: lhs, identifier: rhs)
}

