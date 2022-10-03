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
  static func resolve<A>(
    tags: Set<AnyHashable>,
    args: A,
    with resolver: Resolver
  ) throws -> Any

  /**
   This should just be called `resolve`, but unfortunately
   https://github.com/apple/swift/issues/60318 prevents it.
   
   Oddly, this bug should be affecting the entire codebase,
   but it doesn't seem to.
   */
  static func resolveAsync<A>(
    tags: Set<AnyHashable>,
    args: A,
    with resolver: Resolver
  ) async throws -> Any
}
