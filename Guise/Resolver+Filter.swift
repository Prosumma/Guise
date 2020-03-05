//
//  Resolver+Filter.swift
//  Guise
//
//  Created by Gregory Higley on 3/3/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolver {
  func filter(_ isIncluded: @escaping (Registrations.Element) -> Bool) -> Registrations {
    read().filter(isIncluded)
  }
  
  func filter<Type>(type: Type.Type, in scope: Scope? = nil) -> Registrations {
    func scoped(_ key: Key) -> Bool {
      guard let scope = scope else { return true }
      return key.starts(with: scope)
    }
    return filter{ $0.key.identifier.base is TypeName<Type> && scoped($0.key) }
  }
  
  /// Find all registrations of a given type, optionally within a scope.
  func filter<Type>(registrations type: Type.Type, in scope: Scope? = .registrations) -> [Key: Registration] {
    filter(type: type, in: scope).compactMapValues{ $0 as? Registration }
  }
  
  func filter<Type>(injections type: Type.Type, in scope: Scope? = .injections) -> [Key: Injection] {
    filter(type: type, in: scope).compactMapValues{ $0 as? Injection }
  }
  
  func filter<Type>(assemblies type: Type.Type, in scope: Scope? = .assemblies) -> [Key] {
    Array(filter{ $0.key.identifier.base is TypeName<Type> }.compactMapValues{ $0 as? RegisteredAssembly }.keys)
  }
  
}
