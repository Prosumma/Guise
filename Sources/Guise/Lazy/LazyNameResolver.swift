//
//  LazyNameResolver.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

import Foundation

public final class LazyNameResolver<T> {
  private weak var resolver: (any Resolver)?
  public let name: Set<AnyHashable>
  
  init<A>(_ resolver: any Resolver, name: Set<AnyHashable>, args: A) {
    self.resolver = resolver
    self.name = name
  }
  
  public func resolve<A>(args arg1: A = ()) throws -> T {
    let key = Key(T.self, name: name, args: A.self)
    guard let resolver = resolver else {
      throw ResolutionError(key: key, reason: .noResolver)
    }
    return try resolver.resolve(T.self, name: name, args: arg1)
  }
  
  public func resolve<A>(args arg1: A = ()) async throws -> T {
    let key = Key(T.self, name: name, args: A.self)
    guard let resolver = resolver else {
      throw ResolutionError(key: key, reason: .noResolver)
    }
    return try await resolver.resolve(T.self, name: name, args: arg1)
  }
}

extension LazyNameResolver: LazyResolving {}
