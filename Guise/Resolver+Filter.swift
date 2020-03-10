//
//  Resolver+Filter.swift
//  Guise
//
//  Created by Gregory Higley on 3/3/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public func metafilter<Metadata>(_ predicate: @escaping (Metadata) -> Bool) -> (Any) -> Bool {
  return { metadata in
    guard let metadata = metadata as? Metadata else {
        return false
    }
    return predicate(metadata)
  }
}

public func metafilter<Metadata: Equatable>(_ model: Metadata) -> (Any) -> Bool {
  metafilter{ $0 == model }
}

public extension Resolver {
  func filter(_ isIncluded: @escaping (Registrations.Element) -> Bool) -> Registrations {
    read().filter(isIncluded)
  }
  
  func filter<Type>(type: Type.Type, in scope: Scope? = nil) -> Registrations {
    filter{ (key, _) in key.identifier.base is TypeName<Type> && (scope.flatMap{ key.starts(with: $0) } ?? true) }
  }
  
  /// Find all registrations of a given type, optionally within a scope.
  func filter<Type>(registrations type: Type.Type, in scope: Scope? = .registrations, metafilter: ((Any) -> Bool)? = nil) -> [Key: Registration] {
    filter(type: type, in: scope).compactMapValues{ $0 as? Registration }.filter{ metafilter?($0.value.metadata) ?? true }
  }
  
  func filter<Type>(injections type: Type.Type, in scope: Scope? = .injections) -> [Key: Injection] {
    filter(type: type, in: scope).compactMapValues{ $0 as? Injection }
  }
  
  func filter<Type>(assemblies type: Type.Type, in scope: Scope? = .assemblies) -> [Key] {
    Array(filter{ $0.key.identifier.base is TypeName<Type> }.compactMapValues{ $0 as? RegisteredAssembly }.keys)
  }
  
  func registrations(in scope: Scope? = .registrations) -> [Key: Registration] {
    filter{ scope == nil || $0.key.starts(with: scope!) }.compactMapValues{ $0 as? Registration }
  }
  
}
