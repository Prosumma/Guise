//
//  ResolutionError.swift
//  Guise
//
//  Created by Gregory Higley on 2024-11-05.
//

public struct ResolutionError: Error {
  public let key: AnyKey
  public let reason: Reason

  public init(_ key: AnyKey, reason: Reason) {
    self.key = key
    self.reason = reason
  }

  public init<T>(_ key: Key<T>, reason: Reason) {
    self.init(AnyKey(key), reason: reason)
  }
}

public extension ResolutionError {
  enum Reason: Sendable {
    case notFound
    case invalidArgsType
    case invalidInstanceType
    case requiresAsync
    case noResolver
    case error(Error)
  }
}
