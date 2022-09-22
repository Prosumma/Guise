//
//  ResolutionAdapter.swift
//  Guise
//
//  Created by Greg Higley on 2022-09-21.
//

protocol ResolutionAdapter {
  static func adapt(criteria: Criteria, with resolver: any Resolver) -> Criteria
  
  static func resolve<A>(
    with resolver: any Resolver,
    name: Set<AnyHashable>,
    args: A
  ) throws -> Any
  
  static func resolve<A>(
    with resolver: any Resolver,
    name: Set<AnyHashable>,
    args: A
  ) async throws -> Any
}
