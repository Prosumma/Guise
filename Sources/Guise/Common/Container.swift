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
  private var entries: [Key: any Resolvable] = [:]

  public init(parent: Container? = nil) {
    self.parent = parent
  }
}

extension Container: Resolver {
  public func resolve(criteria: Criteria) -> [Key: any Resolvable] {
    lock.sync {
      let result: [Key: any Resolvable]
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
  public func register<T, A>(
    _ type: T.Type,
    tags: Set<AnyHashable>,
    lifetime: Lifetime,
    factory: @escaping SyncFactory<T, A>
  ) -> Key {
    let key = Key(type, tags: tags, args: A.self)
    let entry = Entry(key: key, lifetime: lifetime, factory: factory)
    register(key: key, resolvable: entry)
    return key
  }
  
  public func register<T, A>(
    _ type: T.Type,
    tags: Set<AnyHashable>,
    lifetime: Lifetime,
    factory: @escaping AsyncFactory<T, A>
  ) -> Key {
    let key = Key(type, tags: tags, args: A.self)
    let entry = Entry(key: key, lifetime: lifetime, factory: factory)
    register(key: key, resolvable: entry)
    return key
  }

  public func unregister(keys: Set<Key>) {
    lock.sync(flags: .barrier) {
      entries = entries.filter { !keys.contains($0.key) }
    }
  }
  
  private func register(key: Key, resolvable: any Resolvable) {
    lock.sync(flags: .barrier) {
      entries[key] = resolvable
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
