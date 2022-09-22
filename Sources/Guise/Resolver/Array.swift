//
//  Array.swift
//  Guise
//
//  Created by Greg Higley on 2022-09-21.
//

extension Array: ResolutionAdapter {
  static func resolve<A>(
    name: Set<AnyHashable>,
    args: A,
    with resolver: Resolver
  ) throws -> Any {
    var array: [Element] = []
    let criteria = Criteria(Element.self, name: .contains(name), args: A.self)
    for (key, _) in resolver.resolve(criteria: criteria) {
      do {
        try array.append(resolver.resolve(Element.self, name: key.name, args: args))
      } catch let error as ResolutionError {
        let criteria = Criteria(key: key)
        guard
          case .notFound = error.reason,
          error.criteria == criteria
        else {
          throw error
        }
      }
    }
    return array
  }
  
  static func resolve<A>(
    name: Set<AnyHashable>,
    args: A,
    with resolver: Resolver
  ) async throws -> Any {
    var array: [Element] = []
    let criteria = Criteria(Element.self, name: .contains(name), args: A.self)
    for (key, _) in resolver.resolve(criteria: criteria) {
      do {
        try await array.append(resolver.resolve(Element.self, name: key.name, args: args))
      } catch let error as ResolutionError {
        let criteria = Criteria(key: key)
        guard
          case .notFound = error.reason,
          error.criteria == criteria
        else {
          throw error
        }
      }
    }
    return array
  }
}
