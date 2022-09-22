//
//  ResolutionAdapter.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-22.
//

/**
 Adapts certain types to be resolved differently
 from the standard way.
 
 Currently the only implementers are `Optional`
 and `Array`.
 */
protocol ResolutionAdapter {
  static func resolve<A>(name: Set<AnyHashable>, args: A, with resolver: Resolver) throws -> Any
  static func resolve<A>(name: Set<AnyHashable>, args: A, with resolver: Resolver) async throws -> Any
}
