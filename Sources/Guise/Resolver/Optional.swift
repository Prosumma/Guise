//
//  Optional.swift
//  Guise
//
//  Created by Greg Higley on 2022-09-21.
//

extension Optional: ResolutionAdapter {
  static func resolve<A>(
    name: Set<AnyHashable>,
    args: A,
    with resolver: Resolver
  ) throws -> Any {
    let wrapped: Wrapped?
    do {
      wrapped = try resolver.resolve(Wrapped.self, name: name, args: args)
    } catch let error as ResolutionError {
      let key = Key(Wrapped.self, name: name, args: A.self)
      guard
        case .notFound = error.reason,
        error.key == key
      else {
        throw error
      }
      wrapped = nil
    }
    return (wrapped as Any)
  }
  
  static func resolve<A>(
    name: Set<AnyHashable>,
    args: A,
    with resolver: Resolver
  ) async throws -> Any {
    let wrapped: Wrapped?
    do {
      wrapped = try await resolver.resolve(Wrapped.self, name: name, args: args)
    } catch let error as ResolutionError {
      let key = Key(Wrapped.self, name: name, args: A.self)
      guard
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
