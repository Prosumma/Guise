//
//  Registrar+Async.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

public extension Registrar {
  func register<T, each A>(
    _ type: T.Type = T.self,
    tags: AnyHashable...,
    lifetime: Lifetime = .transient,
    factory: @escaping (any Resolver, repeat each A) async throws -> T
  ) -> Key {
    let factory: AsyncFactory<T, repeat each A> = { (r: any Resolver, arg: repeat each A) in
      try await factory(r, repeat each arg)
    }
    return register(type, tags: Set(tags), lifetime: lifetime, factory: factory)
  }
}
