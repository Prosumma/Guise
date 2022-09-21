//
//  Resolver+All.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

public extension Resolver  {
  func resolve<T, A>(
    all type: T.Type,
    name: Criteria.NameCriterion? = nil,
    args arg1: A = ()
  ) throws -> [T] {
    let criteria = Criteria(type: type, name: name, args: A.self)
    return try resolve(criteria: criteria).map {
      try self.resolve(entry: $0.value, args: arg1, forKey: $0.key)
    }
  }
  
  func resolve<T, A>(
    all type: T.Type,
    name: Criteria.NameCriterion? = nil,
    args arg1: A = ()
  ) async throws -> [T] {
    let criteria = Criteria(type: type, name: name, args: A.self)
    var result: [T] = []
    for (key, entry) in resolve(criteria: criteria) {
      try await result.append(resolve(entry: entry, args: arg1, forKey: key))
    }
    return result
  }
}
