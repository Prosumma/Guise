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
    /// No entry was found matching the given `Key`.
    case notFound
    /**
     The resolver was `nil`.
     
     This is used only by lazy resolvers, which hold
     a weak reference to the resolver.
     */
    case noResolver
    /**
     An attempt is being made to synchronously
     resolve an `async` registration.
     
     This can be avoided by setting
     `Entry.allowSynchronousResolutionOfAsyncEntries`
     to true, but this has a chance of causing
     deadlocks. See the documentation for `runBlocking`.
     */
    case requiresAsync
    /**
     A catch-all for other errors that might be thrown.
     
     This can be another `ResolutionError`, particularly
     if the dependency of a dependency failed to resolve.
     */
    case error(Error)
  }
}
