//
//  AnySendableHashable.swift
//  Guise
//
//  Created by Gregory Higley on 2024-11-05.
//

public struct AnySendableHashable: Hashable, Sendable {
  private let box: any Boxed
  private let equals: @Sendable (any Boxed) -> Bool

  public init<T: Hashable & Sendable>(_ value: T) {
    self.box = Box(value)
    self.equals = { other in
      guard let box = other as? Box<T> else { return false }
      return box.value == value
    }
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(box)
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.equals(rhs.box)
  }
}

private protocol Boxed: Hashable, Sendable {}

private struct Box<T: Hashable & Sendable>: Boxed {
  let value: T

  init(_ value: T) {
    self.value = value
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(value)
  }
}

public extension Set where Element == AnySendableHashable {
  init<each T: Hashable & Sendable>(elements: repeat each T) {
    self.init()
    for element in repeat each elements {
      insert(AnySendableHashable(element))
    }
  }
}
