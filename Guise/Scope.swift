//
//  Scope.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public struct Scope: Equatable {
  private class Parent {
    let scope: Scope
    init(_ scope: Scope) {
      self.scope = scope
    }
  }

  private let _parent: Parent?
  public let identifier: AnyHashable

  private init() {
    _parent = nil
    identifier = "/"
  }

  public init(parent: Scope, identifier: AnyHashable = UUID()) {
    self._parent = Parent(parent)
    self.identifier = identifier
  }

  public var parent: Scope? {
    return _parent?.scope
  }

  /// `Scope` is not `Hashable` but participates in the hashing of `Key`.
  internal func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
    parent?.hash(into: &hasher)
  }

  public static func ==(lhs: Scope, rhs: Scope) -> Bool {
    return lhs.identifier == rhs.identifier && lhs.parent == rhs.parent
  }

  public static let root = Scope()
}

infix operator ~>: MultiplicationPrecedence

public func ~><R: Hashable>(lhs: Scope, rhs: R) -> Scope {
  return Scope(parent: lhs, identifier: rhs)
}

