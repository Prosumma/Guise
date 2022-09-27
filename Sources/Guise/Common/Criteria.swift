//
//  Criteria.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

/**
 A type used for querying the DI container,
 either by attributes of the `Key`, the `Entry`
 or both.
 */
public struct Criteria: Equatable {
  public let type: String?
  public let name: NameCriterion?
  public let args: String?
  
  public let lifetime: Lifetime?

  public init<T, A>(
    _ type: T.Type,
    name: NameCriterion? = nil,
    args: A.Type,
    lifetime: Lifetime? = nil
  ) {
    self.type = String(reflecting: type)
    self.name = name
    self.args = String(reflecting: args)
    self.lifetime = lifetime
  }

  public init<T>(
    _ type: T.Type,
    name: NameCriterion? = nil,
    lifetime: Lifetime? = nil
  ) {
    self.type = String(reflecting: type)
    self.name = name
    self.args = nil
    self.lifetime = lifetime
  }
  
  public init<A>(
    name: NameCriterion? = nil,
    args: A.Type,
    lifetime: Lifetime? = nil
  ) {
    self.type = nil
    self.name = name
    self.args = String(reflecting: args)
    self.lifetime = lifetime
  }

  public init(
    name: NameCriterion? = nil,
    lifetime: Lifetime? = nil
  ) {
    self.type = nil
    self.name = name
    self.args = nil
    self.lifetime = lifetime
  }

  public init(
    key: Key,
    lifetime: Lifetime? = nil
  ) {
    self.type = key.type
    self.name = .equals(key.name)
    self.args = key.args
    self.lifetime = lifetime
  }
}

func ~= (criteria: Criteria, key: Key) -> Bool {
  let type = criteria.type ?? key.type
  let name = criteria.name ?? .equals(key.name)
  let args = criteria.args ?? key.args
  return type == key.type && name ~= key.name && args == key.args
}

func ~= (criteria: Criteria, entry: Entry) -> Bool {
  let lifetime = criteria.lifetime ?? entry.lifetime
  return lifetime == entry.lifetime
}

func ~= (criteria: Criteria, rhs: Dictionary<Key, Entry>.Element) -> Bool {
  criteria ~= rhs.key && criteria ~= rhs.value
}

public extension Criteria {
  struct NameCriterion: Equatable {
    public enum Comparison {
      case equals
      case contains
    }

    public let name: Set<AnyHashable>
    public let comparison: Comparison

    public init(name: Set<AnyHashable>, comparison: Comparison = .equals) {
      self.name = name
      self.comparison = comparison
    }

    static func equals(_ name: Set<AnyHashable>) -> NameCriterion {
      .init(name: name)
    }

    static func equals(_ name: AnyHashable...) -> NameCriterion {
      .equals(Set(name))
    }

    static func contains(_ name: Set<AnyHashable>) -> NameCriterion {
      .init(name: name, comparison: .contains)
    }

    static func contains(_ name: AnyHashable...) -> NameCriterion {
      .contains(Set(name))
    }

    static func ~= (criterion: NameCriterion, name: Set<AnyHashable>) -> Bool {
      switch criterion.comparison {
      case .equals:
        return criterion.name == name
      case .contains:
        return criterion.name.isSubset(of: name)
      }
    }
  }
}
