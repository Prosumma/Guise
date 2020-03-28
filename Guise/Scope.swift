//
//  Scope.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

/**
 A `Scope` is a hierarchical key constructed from
 hashable values or metatypes. Scopes are one
 of the most fundamental building blocks of Guise.

 A scope consists of an _identifier_, which is required,
 and an optional parent scope. A scope without a
 parent is called a _root scope_.

 ```
 let anonymousUUIDScope = Scope(UUID())
 // This is exactly equivalent to the line above.
 let anonymousScope = Scope()
 let awesome = Scope("awesome")
 let intScope = Scope(7)
 let stringScope = Scope(String.self)
 ```

 The identifier of a scope may be any hashable value
 or a metataype. In the case of `anonymousScope`, the
 identifier is a random `UUID`.

 Hierarchical scopes are constructed using the `/` operator.

 ```
 let awesome: Scope = "awesome"
 let awesomelyCool = awesome / "cool"
 let awesomelyRandom = awesome / UUID()
 let awesomelyRandomString = awesome / UUID() / String.self
 ```

 Every registration in Guise uses a `Scope` as a key.

 ```
 registrar.register(singleton: Api(), in: myScope)
 ```

 When the above registration is made, a `Scope` is
 constructed from the parent scope (`myScope`) and the
 registered type (`Api`): `myScope / Api.self`. This
 is the key used to record this registration.

 An infinite number of registrations can be made in
 `myScope`. We can think of `myScope` as the parent
 or containing scope of the registration.

 When resolution occurs, Guise searches up the scope chain
 */
public struct Scope: Hashable {
    
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
      self = parent?.adopt(child) ?? child
    } else {
      self.identifier = identifier
      self._parent = parent.flatMap(Parent.init)
    }
  }
    
  public init(in parent: Scope? = nil) {
    self.init(UUID(), in: nil)
  }
  
  public init<Type>(_ type: Type.Type, in parent: Scope? = nil) {
    self.init(TypeName<Type>(), in: parent)
  }

  public var parent: Scope? {
    _parent?.scope
  }
  
  public var root: Scope {
    guard let parent = parent else {
      return self
    }
    return parent.root
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

public func /<R: Hashable>(lhs: Scope, rhs: R) -> Scope {
  Scope(rhs, in: lhs)
}

public func /<Type>(lhs: Scope, rhs: Type.Type) -> Key {
  Scope(rhs, in: lhs)
}
