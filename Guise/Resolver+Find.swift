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

  func find<Type>(type: Type.Type, scope: Scope = .root) -> Registration? {
    find(Key(type: type, scope: scope))
  }

  func filter(type: String? = nil, in scope: Scope = .root, metafilter: ((Any) -> Bool)? = nil) -> [RegistrationEntry] {
    var registrations = filter { (type == nil || $0.key.type == type) && $0.key.starts(with: scope) }
    if let metafilter = metafilter {
      registrations = registrations.filter{ metafilter($0.value.metadata) }
    }
    return registrations
  }
  
  func filter<Type, Metadata>(type: Type.Type, in scope: Scope = .root, metafilter: @escaping (Metadata) -> Bool) -> [RegistrationEntry] {
    filter(type: String(reflecting: type), in: scope) { (metadata: Any) in
      guard let metadata = metadata as? Metadata else { return false }
      return metafilter(metadata)
    }
  }
  
  func filter<Type, Metadata: Equatable>(type: Type.Type, in scope: Scope = .root, metadata: Metadata) -> [RegistrationEntry] {
    filter(type: type, in: scope) { $0 == metadata }
  }
  
  func filter<Type>(type: Type.Type, in scope: Scope = .root) -> [RegistrationEntry] {
    filter(type: String(reflecting: type), in: scope, metafilter: nil)
  }

}
