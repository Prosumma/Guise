//
//  Container.swift
//  Guise
//
//  Created by Gregory Higley on 2024-11-06.
//

import Foundation
import OrderedCollections
import Semaphore

public final class Container: @unchecked Sendable {
  private let parent: Container?
  private var assemblies: OrderedSet<AssemblyEntry> = []
  private var entries: [AnyKey: Entry] = [:]
  private let queue = DispatchQueue(label: "Guise.Container.Entry.lock", attributes: .concurrent)

  public init(parent: Container? = nil) {
    self.parent = parent
  }
}

extension Container: Resolver {
  public func find<T>(_ criteria: Criteria<T>) -> Set<Key<T>> {
    queue.sync {
      var result: Set<Key<T>> = parent?.find(criteria) ?? []
      for key in entries.keys where criteria.matches(key) {
        result.insert(Key<T>(tagset: key.tagset))
      }
      return result
    }
  }

  /**
    * Returns the entry for the given key.
    *
    * Why don't we use an actor here or some other simpler
    * synchronization mechanism? Because actors serialize
    * all access to state when reading or writing. But we
    * need to have multiple simultaneous readers but block
    * everything on writes. This is a classic readers-writers
    * problem, which is why we use a concurrent queue.
   */
  public subscript<T>(key: Key<T>) -> Entry? {
    get {
      queue.sync {
        entries[AnyKey(key)] ?? parent?[key]
      }
    }
    set {
      // We use a barrier here to ensure that no other
      // operations are happening on the queue when we
      // set the new value. This is why we can't use
      // an actor.
      queue.sync(flags: .barrier) {
        self.entries[AnyKey(key)] = newValue
      }
    }
  }
}

extension Container {
  private struct AssemblyEntry: Hashable {
    let hash: String
    let assembly: any Assembly

    init<A: Assembly>(_ assembly: A) {
      self.hash = String(reflecting: A.self)
      self.assembly = assembly
    }

    func hash(into hasher: inout Hasher) {
      hasher.combine(hash)
    }

    static func == (lhs: AssemblyEntry, rhs: AssemblyEntry) -> Bool {
      lhs.hash == rhs.hash
    }
  }
}

extension Container: Registrar {
  public func register<each A: Assembly>(assemblies: repeat each A) {
    var ix: Int?
    for assembly in repeat each assemblies {
      let entry = AssemblyEntry(assembly)
      var inserted = false
      if let ix {
        (inserted, _) = self.assemblies.insert(entry, at: ix)
      } else {
        (inserted, ix) = self.assemblies.append(entry)
      }
      if inserted {
        assembly.register(in: self)
      }
    }
  }
}

extension Container: Assembler {
  public func assemble<each A: Assembly>(_ assemblies: repeat each A) async throws {
    register(assemblies: repeat each assemblies)
    for assembly in self.assemblies.map(\.assembly).reversed() {
      try await assembly.registered(to: self)
    }
    self.assemblies.removeAll()
  }
}
