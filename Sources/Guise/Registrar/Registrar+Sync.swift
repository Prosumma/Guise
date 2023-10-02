//
//  Registrar.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

public extension Registrar {
    func register<T, each A>(_ type: T.Type = T.self, tags: AnyHashable..., lifetime: Lifetime = .transient, factory: @escaping (any Resolver, repeat each A) throws -> T) -> Key {
        let factory: SyncFactory<T, repeat each A> = { (r: any Resolver, arg: repeat each A) in
            try factory(r, repeat each arg)
        }
        return register(type, tags: Set(tags), lifetime: lifetime, factory: factory)
    }
}

public extension Registrar {
  @discardableResult
  func register<T>(
    _ type: T.Type = T.self,
    tags: AnyHashable...,
    lifetime: Lifetime = .transient,
    instance: @escaping @autoclosure () -> T
  ) -> Key {
    let factory: SyncFactory<T, Void> = { _, _ in
      instance()
    }
    return register(type, tags: Set(tags), lifetime: lifetime, factory: factory)
  }
}
