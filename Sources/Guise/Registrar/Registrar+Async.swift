//
//  Registrar+Async.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

public extension Registrar {
#if swift(>=5.9)
  @discardableResult
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
#else
  @discardableResult
  func register<T>(
    _ type: T.Type = T.self,
    tags: AnyHashable...,
    lifetime: Lifetime = .transient,
    factory: @escaping (any Resolver) async throws -> T
  ) -> Key {
    let factory: (any Resolver, Void) async throws -> T = { r, _ in
      try await factory(r)
    }
    return register(type, tags: Set(tags), lifetime: lifetime, factory: factory)
  }

  @discardableResult
  func register<T, A>(
    _ type: T.Type = T.self,
    tags: AnyHashable...,
    lifetime: Lifetime = .transient,
    factory: @escaping AsyncFactory<T, A>
  ) -> Key {
    register(type, tags: Set(tags), lifetime: lifetime, factory: factory)
  }

  @discardableResult
  func register<T, A1, A2>(
    _ type: T.Type = T.self,
    tags: AnyHashable...,
    lifetime: Lifetime = .transient,
    factory: @escaping (any Resolver, A1, A2) async throws -> T
  ) -> Key {
    let factory: AsyncFactory<T, (A1, A2)> = { r, arg in
      try await factory(r, arg.0, arg.1)
    }
    return register(type, tags: Set(tags), lifetime: lifetime, factory: factory)
  }

  @discardableResult
  func register<T, A1, A2, A3>(
    _ type: T.Type = T.self,
    tags: AnyHashable...,
    lifetime: Lifetime = .transient,
    factory: @escaping (any Resolver, A1, A2, A3) async throws -> T
  ) -> Key {
    let factory: AsyncFactory<T, (A1, A2, A3)> = { r, arg in
      try await factory(r, arg.0, arg.1, arg.2)
    }
    return register(type, tags: Set(tags), lifetime: lifetime, factory: factory)
  }

  @discardableResult
  func register<T, A1, A2, A3, A4>(
    _ type: T.Type = T.self,
    tags: AnyHashable...,
    lifetime: Lifetime = .transient,
    factory: @escaping (any Resolver, A1, A2, A3, A4) async throws -> T
  ) -> Key {
    let factory: AsyncFactory<T, (A1, A2, A3, A4)> = { r, arg in
      try await factory(r, arg.0, arg.1, arg.2, arg.3)
    }
    return register(type, tags: Set(tags), lifetime: lifetime, factory: factory)
  }

  @discardableResult
  func register<T, A1, A2, A3, A4, A5>(
    _ type: T.Type = T.self,
    tags: AnyHashable...,
    lifetime: Lifetime = .transient,
    factory: @escaping (any Resolver, A1, A2, A3, A4, A5) async throws -> T
  ) -> Key {
    let factory: AsyncFactory<T, (A1, A2, A3, A4, A5)> = { r, arg in
      try await factory(r, arg.0, arg.1, arg.2, arg.3, arg.4)
    }
    return register(type, tags: Set(tags), lifetime: lifetime, factory: factory)
  }

  @discardableResult
  func register<T, A1, A2, A3, A4, A5, A6>(
    _ type: T.Type = T.self,
    tags: AnyHashable...,
    lifetime: Lifetime = .transient,
    factory: @escaping (any Resolver, A1, A2, A3, A4, A5, A6) async throws -> T
  ) -> Key {
    let factory: AsyncFactory<T, (A1, A2, A3, A4, A5, A6)> = { r, arg in
      try await factory(r, arg.0, arg.1, arg.2, arg.3, arg.4, arg.5)
    }
    return register(type, tags: Set(tags), lifetime: lifetime, factory: factory)
  }

  @discardableResult
  func register<T, A1, A2, A3, A4, A5, A6, A7>(
    _ type: T.Type = T.self,
    tags: AnyHashable...,
    lifetime: Lifetime = .transient,
    factory: @escaping (any Resolver, A1, A2, A3, A4, A5, A6, A7) async throws -> T
  ) -> Key {
    let factory: AsyncFactory<T, (A1, A2, A3, A4, A5, A6, A7)> = { r, arg in
      try await factory(r, arg.0, arg.1, arg.2, arg.3, arg.4, arg.5, arg.6)
    }
    return register(type, tags: Set(tags), lifetime: lifetime, factory: factory)
  }

  @discardableResult
  func register<T, A1, A2, A3, A4, A5, A6, A7, A8>(
    _ type: T.Type = T.self,
    tags: AnyHashable...,
    lifetime: Lifetime = .transient,
    factory: @escaping (any Resolver, A1, A2, A3, A4, A5, A6, A7, A8) async throws -> T
  ) -> Key {
    let factory: AsyncFactory<T, (A1, A2, A3, A4, A5, A6, A7, A8)> = { r, arg in
      try await factory(r, arg.0, arg.1, arg.2, arg.3, arg.4, arg.5, arg.6, arg.7)
    }
    return register(type, tags: Set(tags), lifetime: lifetime, factory: factory)
  }

  @discardableResult
  func register<T, A1, A2, A3, A4, A5, A6, A7, A8, A9>(
    _ type: T.Type = T.self,
    tags: AnyHashable...,
    lifetime: Lifetime = .transient,
    factory: @escaping (any Resolver, A1, A2, A3, A4, A5, A6, A7, A8, A9) async throws -> T
  ) -> Key {
    let factory: AsyncFactory<T, (A1, A2, A3, A4, A5, A6, A7, A8, A9)> = { r, arg in
      try await factory(r, arg.0, arg.1, arg.2, arg.3, arg.4, arg.5, arg.6, arg.7, arg.8)
    }
    return register(type, tags: Set(tags), lifetime: lifetime, factory: factory)
  }
#endif
}
