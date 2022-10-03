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
  public let tags: Tags?
  public let args: String?

  public let lifetime: Lifetime?

  public init<T, A>(
    _ type: T.Type,
    tags: Tags? = nil,
    args: A.Type,
    lifetime: Lifetime? = nil
  ) {
    self.type = String(reflecting: type)
    self.tags = tags
    self.args = String(reflecting: args)
    self.lifetime = lifetime
  }

  public init<T>(
    _ type: T.Type,
    tags: Tags? = nil,
    lifetime: Lifetime? = nil
  ) {
    self.type = String(reflecting: type)
    self.tags = tags
    self.args = nil
    self.lifetime = lifetime
  }

  public init<A>(
    tags: Tags? = nil,
    args: A.Type,
    lifetime: Lifetime? = nil
  ) {
    self.type = nil
    self.tags = tags
    self.args = String(reflecting: args)
    self.lifetime = lifetime
  }

  public init(
    tags: Tags? = nil,
    lifetime: Lifetime? = nil
  ) {
    self.type = nil
    self.tags = tags
    self.args = nil
    self.lifetime = lifetime
  }

  public init(
    key: Key,
    lifetime: Lifetime? = nil
  ) {
    self.type = key.type
    self.tags = .equals(key.tags)
    self.args = key.args
    self.lifetime = lifetime
  }
}

func ~= (criteria: Criteria, key: Key) -> Bool {
  let type = criteria.type ?? key.type
  let tags = criteria.tags ?? .equals(key.tags)
  let args = criteria.args ?? key.args
  return type == key.type && tags ~= key.tags && args == key.args
}

func ~= (criteria: Criteria, entry: Entry) -> Bool {
  let lifetime = criteria.lifetime ?? entry.lifetime
  return lifetime == entry.lifetime
}

func ~= (criteria: Criteria, rhs: Dictionary<Key, Entry>.Element) -> Bool {
  criteria ~= rhs.key && criteria ~= rhs.value
}

public extension Criteria {
  struct Tags: Equatable {
    public enum Comparison {
      case equals
      case contains
    }

    public let tags: Set<AnyHashable>
    public let comparison: Comparison

    public init(tags: Set<AnyHashable>, comparison: Comparison = .equals) {
      self.tags = tags
      self.comparison = comparison
    }

    static func equals(_ tags: Set<AnyHashable>) -> Tags {
      .init(tags: tags)
    }

    static func equals(_ tags: AnyHashable...) -> Tags {
      .equals(Set(tags))
    }

    static func contains(_ tags: Set<AnyHashable>) -> Tags {
      .init(tags: tags, comparison: .contains)
    }

    static func contains(_ tags: AnyHashable...) -> Tags {
      .contains(Set(tags))
    }

    static func ~= (criterion: Tags, tags: Set<AnyHashable>) -> Bool {
      switch criterion.comparison {
      case .equals:
        return criterion.tags == tags
      case .contains:
        return criterion.tags.isSubset(of: tags)
      }
    }
  }
}
