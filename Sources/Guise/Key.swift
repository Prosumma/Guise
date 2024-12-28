//
//  File.swift
//  Guise
//
//  Created by Gregory Higley on 2024-11-05.
//

import Foundation

public protocol Keyed: Sendable, Hashable {
  var type: String { get }
  var tagset: Set<AnySendableHashable> { get }
}

public struct Key<T>: Keyed {
  public let type: String
  public let tagset: Set<AnySendableHashable>

  public init(tagset: Set<AnySendableHashable>) {
    self.type = String(reflecting: T.self)
    self.tagset = tagset
  }

  public init?(_ key: any Keyed) {
    self.init(tagset: key.tagset)
    if key.type != type {
      return nil
    }
  }

  public init<each Tag: Hashable & Sendable>(tags: repeat each Tag) {
    self.init(tagset: .init(elements: repeat each tags))
  }
}

public struct AnyKey: Keyed {
  public let type: String
  public let tagset: Set<AnySendableHashable>

  public init(_ key: any Keyed) {
    self.type = key.type
    self.tagset = key.tagset
  }

  public init<T>(_ type: T.Type, tagset: Set<AnySendableHashable>) {
    self.type = String(reflecting: type)
    self.tagset = tagset
  }

  public init<T, each Tag: Hashable & Sendable>(_ type: T.Type, tags: repeat each Tag) {
    self.init(type, tagset: .init(elements: repeat each tags))
  }
}

public func == <T>(lhs: Key<T>, rhs: AnyKey) -> Bool {
  lhs.type == rhs.type && lhs.tagset == rhs.tagset
}

public func == <T>(lhs: AnyKey, rhs: Key<T>) -> Bool {
  lhs.type == rhs.type && lhs.tagset == rhs.tagset
}

public func != <T>(lhs: Key<T>, rhs: AnyKey) -> Bool {
  !(lhs == rhs)
}

public func != <T>(lhs: AnyKey, rhs: Key<T>) -> Bool {
  !(lhs == rhs)
}
