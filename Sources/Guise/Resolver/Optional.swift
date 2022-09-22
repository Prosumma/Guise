//
//  Optional.swift
//  Guise
//
//  Created by Greg Higley on 2022-09-21.
//

import Foundation

extension Optional: ResolutionAdapter {
  static func adapt(criteria: Criteria, with resolver: any Resolver) -> Criteria {
    resolver.adapt(Wrapped.self, criteria: Criteria(Wrapped.self, name: criteria.name, args: criteria.args))
  }
  
  static func resolve<A>(
    with resolver: any Resolver,
    name: Set<AnyHashable>,
    args: A
  ) throws -> Any {
    try resolver.resolve(Wrapped.self, name: name, args: args)
  }
  
  static func resolve<A>(
    with resolver: any Resolver,
    name: Set<AnyHashable>,
    args: A
  ) async throws -> Any {
    try await resolver.resolve(Wrapped.self, name: name, args: args)
  }
}
