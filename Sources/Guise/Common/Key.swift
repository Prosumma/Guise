//
//  Key.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

/// A type which serves as a key for an `Entry`.
public struct Key: Equatable, Hashable {
  public let type: String
  public let args: String
  public let tags: Set<AnyHashable>

  public init<T, A>(
    _ type: T.Type,
    tags: Set<AnyHashable>,
    args: A.Type = Void.self
  ) {
    self.type = String(reflecting: type)
    self.tags = tags
    self.args = String(reflecting: args)
  }

  public init<T, A>(
    _ type: T.Type,
    tags: AnyHashable...,
    args: A.Type = Void.self
  ) {
    self.type = String(reflecting: type)
    self.tags = Set(tags)
    self.args = String(reflecting: args)
  }
}

extension Key: CustomStringConvertible {
  public var description: String {
    var tags: [String] = []
    for tag in self.tags {
      if let name = tag.base as? CustomDebugStringConvertible {
        tags.append("\(name.debugDescription)")
      } else {
        tags.append("\(tag.base)")
      }
    }
    tags.sort()
    return "Key(\(type), tags: \(tags.joined(separator: ", ")), args: \(args))"
  }
}
