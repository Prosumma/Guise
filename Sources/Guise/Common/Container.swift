//
//  Container.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

import Foundation
import OrderedCollections

public class Container {
  public let parent: Container?
  private let lock = DispatchQueue(label: "Guise Container Entry Lock", attributes: .concurrent)
  private var entries: [Key: Entry] = [:]

  public init(parent: Container? = nil) {
    self.parent = parent
  }
}

extension Container: Resolver {
  public func resolve(criteria: Criteria) -> [Key: Entry] {
    lock.sync {
      let result: [Key: Entry]
      if let parent {
        let parentEntries = parent.resolve(criteria: criteria)
        let childEntries = entries.filter { criteria ~= $0 }
        // Entries in this container override entries in its parent.
        result = parentEntries.merging(childEntries, uniquingKeysWith: { _, new in new })
      } else {
        result = entries.filter { criteria ~= $0 }
      }
      return result
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
}

extension Container: Assembler {
  public func assemble(_ assembly: some Assembly) {
    var assemblies: OrderedDictionary<String, any Assembly> = [:]
    add(assembly: assembly, to: &assemblies)
    for assembly in assemblies.values {
      assembly.register(in: self)
    }
    for assembly in assemblies.values {
      assembly.registered(to: self)
    }
  }

  private func add(assembly: any Assembly, to assemblies: inout OrderedDictionary<String, any Assembly>) {
    let key = String(reflecting: type(of: assembly))
    guard !assemblies.keys.contains(key) else { return }
    for dependentAssembly in assembly.dependentAssemblies {
      add(assembly: dependentAssembly, to: &assemblies)
    }
    assemblies[key] = assembly
  }
}
