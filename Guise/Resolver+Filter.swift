//
//  Resolver+Filter.swift
//  Guise
//
//  Created by Gregory Higley on 3/3/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public func metafilter<Metadata>(_ predicate: @escaping Predicate<Metadata>) -> Predicate<Registration> {
  return { metadata in
    guard let metadata = metadata as? Metadata else {
        return false
    }
    return predicate(metadata)
  }
}

public func metadata<Metadata: Equatable>(_ model: Metadata) -> Predicate<Registration> {
  metafilter{ $0 == model }
}

public func scope(_ scope: Scope) -> Predicate<Registration> {
  return { entry in
    entry.key.starts(with: scope)
  }
}

public func key<K>(type: K.Type) -> Predicate<Registration> {
  return { entry in
    entry.key.identifier.base is TypeName<K>
  }
}

public extension Resolver {
  /**
   Filter entries in the resolver.
   
   Use higher-order functions to make filtering composable, e.g.,
   
   ```swift
   let predicate = key(type: Foo.self) && scope(.registrations) && metadata(FooMetadata(3))
   resolver.filter(predicate)
   ```
   */
  func filter(_ isIncluded: Predicate<Registration>) -> Registrations {
    var entries: Registrations = [:]
    let iterator = makeIterator()
    while let next = iterator.next() {
      if isIncluded(next) {
        entries[next.key] = next.value
      }
    }
    return entries
  }
  
  /**
   Filter entries in the resolver.
   
   Use higher-order functions to make filtering composable, e.g.,
   
   ```swift
   let registrations = filter(valueType: Registration.self, isIncluded: scope(.default))
   ```
   */
  func filter<R>(registeredType: R.Type = R.self, _ isIncluded: Predicate<Registration>? = nil) -> [Key: R] {
    var entries: [Key: R] = [:]
    let iterator = makeIterator()
    while let next = iterator.next() {
      if let value = next.value as? R, isIncluded?(next) ?? true {
        entries[next.key] = value
      }
    }
    return entries
  }
  
  func factories(_ isIncluded: @escaping Predicate<Registration>) -> [Key: FactoryRegistration] {
    filter(isIncluded)
  }
}
