//
//  Criteria.swift
//  Guise
//
//  Created by Gregory Higley on 2024-11-05.
//

public struct Criteria<T> {
  // swiftlint:disable:next type_name
  public enum Op {
    case equal, subset
  }

  public let type: String
  public let op: Op
  public let tags: Set<AnySendableHashable>

  public init(op: Op = .equal, tagset: Set<AnySendableHashable>) {
    self.type = String(reflecting: T.self)
    self.op = op
    self.tags = tagset
  }

  public init<each Tag: Sendable & Hashable>(op: Op = .equal, tags: repeat each Tag) {
    self.init(op: op, tagset: .init(elements: repeat each tags))
  }

  public init(from key: Key<T>) {
    self.type = key.type
    self.op = .equal
    self.tags = key.tagset
  }

  public func matches(_ key: AnyKey) -> Bool {
    guard key.type == type else { return false }
    switch op {
    case .equal:
      return key.tagset == tags
    case .subset:
      return tags.isEmpty || tags.isSubset(of: key.tagset)
    }
  }

  public func matches(_ key: Key<T>) -> Bool {
    switch op {
    case .equal:
      return key.tagset == tags
    case .subset:
      return tags.isEmpty || tags.isSubset(of: key.tagset)
    }
  }
}
