//
//  Array.swift
//  Guise
//
//  Created by Greg Higley on 2022-09-21.
//

extension Array: ResolutionAdapter {
  static func adapt(criteria: Criteria, with resolver: any Resolver) -> Criteria {
    resolver.adapt(Element.self, criteria: Criteria(Element.self, name: criteria.name, args: criteria.args))
  }
  
  static func resolve<A>(
    with resolver: any Resolver,
    name: Set<AnyHashable>,
    args: A
  ) throws -> Any {
    let criteria = adapt(criteria: Criteria(Element.self, name: .contains(name), args: A.self), with: resolver)
    return try resolver.resolve(criteria: criteria).map { (key, _) in
      try resolver.resolve(Element.self, name: key.name, args: args)
    }
  }
  
  static func resolve<A>(
    with resolver: any Resolver,
    name: Set<AnyHashable>,
    args: A
  ) async throws -> Any {
    let criteria = adapt(criteria: Criteria(Element.self, name: .contains(name), args: A.self), with: resolver)
    var result: [Element] = []
    for (key, _) in resolver.resolve(criteria: criteria) {
      try await result.append(resolver.resolve(Element.self, name: key.name, args: args))
    }
    return result
  }
}
