//
//  ResolutionError.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

public struct ResolutionError: Error {
  public let criteria: Criteria
  public let reason: Reason
  
  public init(criteria: Criteria, reason: Reason) {
    self.criteria = criteria
    self.reason = reason
  }
  
  public init(key: Key, reason: Reason) {
    self.init(criteria: .init(key: key), reason: reason)
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
