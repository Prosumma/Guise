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
  public let name: Set<AnyHashable>

  public init<T, A>(
    _ type: T.Type,
    name: Set<AnyHashable>,
    args: A.Type = Void.self
  ) {
    self.type = String(reflecting: type)
    self.name = name
    self.args = String(reflecting: args)
  }

  public init<T, A>(
    _ type: T.Type,
    name: AnyHashable...,
    args: A.Type = Void.self
  ) {
    self.type = String(reflecting: type)
    self.name = Set(name)
    self.args = String(reflecting: args)
  }
}

extension Key: CustomStringConvertible {
  public var description: String {
    var names: [String] = []
    for name in name {
      if let name = name.base as? CustomDebugStringConvertible {
        names.append("\(name.debugDescription)")
      } else {
        names.append("\(name.base)")
      }
    }
    names.sort()
    return "Key(\(type), name: \(names.joined(separator: ", ")), args: \(args))"
  }
}
