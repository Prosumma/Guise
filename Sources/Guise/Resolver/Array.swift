//
//  Array.swift
//  Guise
//
//  Created by Greg Higley on 2022-09-21.
//

public struct ArrayResolutionConfig {
  static var throwResolutionErrorWhenNotFound = false
}

extension Array: ResolutionAdapter {
  static func resolve<A>(
    name: Set<AnyHashable>,
    args: A,
    with resolver: Resolver
  ) throws -> Any {
    var array: [Element] = []
    let criteria = Criteria(Element.self, name: .contains(name), args: A.self)
    for (key, _) in resolver.resolve(criteria: criteria) {
      try array.append(resolver.resolve(Element.self, name: key.tags, args: args))
    }
    if ArrayResolutionConfig.throwResolutionErrorWhenNotFound && array.isEmpty {
      let key = Key([Element].self, tags: name, args: A.self)
      throw ResolutionError(key: key, reason: .notFound)
    }
    return array
  }

  static func resolveAsync<A>(
    name: Set<AnyHashable>,
    args: A,
    with resolver: Resolver
  ) async throws -> Any {
    var array: [Element] = []
    let criteria = Criteria(Element.self, name: .contains(name), args: A.self)
    for (key, _) in resolver.resolve(criteria: criteria) {
      try await array.append(resolver.resolve(Element.self, name: key.tags, args: args))
    }
    if ArrayResolutionConfig.throwResolutionErrorWhenNotFound && array.isEmpty {
      let key = Key([Element].self, tags: name, args: A.self)
      throw ResolutionError(key: key, reason: .notFound)
    }
    return array
  }
}
