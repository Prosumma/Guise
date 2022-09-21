//
//  Criteria.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

/// A type used for querying the DI container
public struct Criteria {
  public let type: String?
  public let name: NameCriterion?
  public let args: String?
  
  public init<T, A>(
    type: T.Type,
    name: NameCriterion?,
    args: A.Type
  ) {
    self.type = String(reflecting: type)
    self.name = name
    self.args = String(reflecting: args)
  }
  
  public init<T>(
    _ type: T.Type,
    name: NameCriterion? = nil
  ) {
    self.type = String(reflecting: type)
    self.name = name
    args = nil
  }
  
  public init(name: NameCriterion? = nil) {
    self.type = nil
    self.name = name
    self.args = nil
  }
  
  public init(key: Key) {
    self.type = key.type
    self.name = .equals(key.name)
    self.args = key.args
  }
}

func ~= (criteria: Criteria, key: Key) -> Bool {
  (criteria.type ?? key.type) == key.type &&
  (criteria.name ?? .equals(key.name)) ~= key.name &&
  (criteria.args ?? key.args) == key.args
}

public extension Criteria {
  struct NameCriterion {
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
