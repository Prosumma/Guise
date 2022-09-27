//
//  Container.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

import Foundation
import OrderedCollections

public class Container {
  private let lock = DispatchQueue(label: "Guise Container Entry Lock", attributes: .concurrent)
  private var entries: [Key: Entry] = [:]

  private let assemblyLock = DispatchQueue(label: "Guise Assembly Entry Lock")
  private var assemblies: OrderedDictionary<String, Assembly> = [:]
}

extension Container: Resolver {
  public func resolve(criteria: Criteria) -> [Key: Entry] {
    lock.sync {
      entries.filter { criteria ~= $0 }
    }
  }
}

extension Container: Registrar {
  public func register(key: Key, entry: Entry) {
    lock.sync(flags: .barrier) {
      entries[key] = entry
    }
  }

  public func unregister(keys: Set<Key>) {
    lock.sync(flags: .barrier) {
      entries = entries.filter { !keys.contains($0.key) }
    }
  }

  public func register<A: Assembly>(assembly: A) {
    assemblyLock.sync {
      let key = String(reflecting: A.self)
      if !assemblies.keys.contains(key) {
        assemblies[key] = assembly
      }
    }
  }
}

extension Container: Assembler {
  public func assemble() throws {
    for assembly in assemblies.values {
      assembly.register(in: self)
    }
    try assemblyLock.sync {
      for assembly in assemblies.values {
        try assembly.registered(to: self)
      }
      assemblies = [:]
    }
  }
}
