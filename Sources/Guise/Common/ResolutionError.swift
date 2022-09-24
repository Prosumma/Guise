//
//  ResolutionError.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

public struct ResolutionError: Error {
  public let key: Key
  public let reason: Reason

  public init(key: Key, reason: Reason) {
    self.key = key
    self.reason = reason
  }
}

public extension ResolutionError {
  enum Reason: Error {
    case notFound
    case noResolver
    case requiresAsync
    case error(Error)
  }
}
