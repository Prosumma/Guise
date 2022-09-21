//
//  Container.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

import Foundation

public class Container {
  private let lock = DispatchQueue(label: "Guise Container", attributes: .concurrent)
  private var entries: [Key: Entry] = [:]
}

extension Container: Resolver {
  public func resolve(criteria: Criteria) -> [Key : Entry] {
    lock.sync {
      entries.filter { criteria ~= $0.key }
    }
  }
  
  public func unregister(keys: Set<Key>) {
    lock.sync(flags: .barrier) {
      entries = entries.filter { !keys.contains($0.key) }
    }
  }
}

extension Container: Registrar {
  public func register(key: Key, entry: Entry) {
    lock.sync(flags: .barrier) {
      entries[key] = entry
    }
  }
}
