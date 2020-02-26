//
//  Resolver+Find.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolver {
  func find(_ key: Key) -> Registration? {
    if let registration = self[key] {
      return registration
    }
    if let key = key.parent {
      return find(key)
    }
    return nil
  }

  func find<Type>(type: Type.Type, in scope: Scope = .default) -> Registration? {
    find(Key(type, in: scope))
  }

  func filter(type: String? = nil, in scope: Scope = .default, metafilter: ((Any) -> Bool)? = nil) -> [RegistrationEntry] {
    // Keys are filtered inside of the GCD lock.
    var registrations = filter { (type == nil || $0.key.type == type) && $0.key.starts(with: scope) }
    if let metafilter = metafilter {
      // Metadata is filtered outside of the GCD lock.
      registrations = registrations.filter{ metafilter($0.value.metadata) }
    }
    return registrations
  }
  
  func filter<Type, Metadata>(type: Type.Type, in scope: Scope = .default, metafilter: @escaping (Metadata) -> Bool) -> [RegistrationEntry] {
    filter(type: String(reflecting: type), in: scope) { (metadata: Any) in
      guard let metadata = metadata as? Metadata else { return false }
      return metafilter(metadata)
    }
  }
  
  func filter<Type, Metadata: Equatable>(type: Type.Type, in scope: Scope = .default, metadata: Metadata) -> [RegistrationEntry] {
    filter(type: type, in: scope) { $0 == metadata }
  }
  
  func filter<Type>(type: Type.Type, in scope: Scope = .default) -> [RegistrationEntry] {
    filter(type: String(reflecting: type), in: scope, metafilter: nil)
  }

}
