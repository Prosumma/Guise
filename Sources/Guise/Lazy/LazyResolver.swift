//
//  LazyResolver.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

/**
 A lazy resolver which resolves instances of the type `T`.
 Name and arguments must be specified when resolving.
 */
public final class LazyResolver<T> {
  weak var resolver: (any Resolver)?
  
  init<A>(_ resolver: any Resolver, name: Set<AnyHashable>, args: A) {
    self.resolver = resolver
  }
  
  public func resolve<A>(name: Set<AnyHashable>, args arg1: A) throws -> T {
    let key = Key(T.self, name: name, args: A.self)
    guard let resolver = resolver else {
      throw ResolutionError(key: key, reason: .noResolver)
    }
    return try resolver.resolve(T.self, name: name, args: arg1)
  }
  
  public func resolve<A>(name: Set<AnyHashable>, args arg1: A) async throws -> T {
    let key = Key(T.self, name: name, args: A.self)
    guard let resolver = resolver else {
      throw ResolutionError(key: key, reason: .noResolver)
    }
    return try await resolver.resolve(T.self, name: name, args: arg1)
  }
}

extension LazyResolver: LazyResolving {}
