//
//  File.swift
//  
//
//  Created by Greg Higley on 9/21/22.
//

import Foundation

protocol OptionalResolving {
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

extension Optional: OptionalResolving {
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
