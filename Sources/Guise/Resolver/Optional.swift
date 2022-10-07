//
//  Optional.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

public enum OptionalResolutionConfig {
  static var throwResolutionErrorWhenNotFound = false
}

extension Optional: ResolutionAdapter {
  static func resolve<A>(
    tags: Set<AnyHashable>,
    args: A,
    with resolver: Resolver
  ) throws -> Any {
    let wrapped: Wrapped?
    do {
      wrapped = try resolver.resolve(Wrapped.self, tags: tags, args: args)
    } catch let error as ResolutionError {
      let key = Key(Wrapped.self, tags: tags, args: A.self)
      guard
        !OptionalResolutionConfig.throwResolutionErrorWhenNotFound,
        case .notFound = error.reason,
        error.key == key
      else {
        throw error
      }
      wrapped = nil
    }
    return (wrapped as Any)
  }

  static func resolveAsync<A>(
    tags: Set<AnyHashable>,
    args: A,
    with resolver: Resolver
  ) async throws -> Any {
    let wrapped: Wrapped?
    do {
      wrapped = try await resolver.resolve(Wrapped.self, tags: tags, args: args)
    } catch let error as ResolutionError {
      let key = Key(Wrapped.self, tags: tags, args: A.self)
      guard
        !OptionalResolutionConfig.throwResolutionErrorWhenNotFound,
        case .notFound = error.reason,
        error.key == key
      else {
        throw error
      }
      wrapped = nil
    }
    return (wrapped as Any)
  }
}
