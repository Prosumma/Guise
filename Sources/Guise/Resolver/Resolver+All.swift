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
    return try resolve(criteria: criteria).values.map { try $0.resolve(self, arg1) as! T }
  }
  
  func resolve<T, A>(
    all type: T.Type,
    name: Criteria.NameCriterion? = nil,
    args arg1: A = ()
  ) async throws -> [T] {
    let criteria = Criteria(type: type, name: name, args: A.self)
    var result: [T] = []
    for entry in resolve(criteria: criteria).values {
      try await result.append(entry.resolve(self, arg1) as! T)
    }
    return result
  }
}
