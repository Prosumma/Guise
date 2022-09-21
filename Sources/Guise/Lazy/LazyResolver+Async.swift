//
//  LazyResolver+Async.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

public extension LazyResolver {
  func resolve<A>(name: AnyHashable..., args arg1: A = ()) async throws -> T {
    try await resolve(name: Set(name), args: arg1)
  }
}
