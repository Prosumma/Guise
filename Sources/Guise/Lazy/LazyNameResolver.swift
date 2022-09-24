//
//  LazyNameResolver.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

import Foundation

/**
 A lazy resolver which stores a `name` for later use
 when it is resolved.
 
 To instantiate a `LazyNameResolver`, use the `Resolver`
 itself:
 
 ```swift
 let lnr: LazyNameResolver<Service> = try resolver.resolve(name: "s")
 ```
 
 Any name passed during resolution is stored by the `LazyNameResolver`
 to be used when resolving with it:
 
 ```swift
 let service = try lnr.resolve()
 ```
 
 This implicitly uses the name "s" when resolving.
 
 Any arguments passed when constructing the `LazyNameResolver` are
 ignored and must be passed when resolving:
 
 ```
 let service = try lnr.resolve(args: 1)
 ```
 */
public final class LazyNameResolver<T> {
  private weak var resolver: (any Resolver)?
  public let name: Set<AnyHashable>

  init<A>(_ resolver: any Resolver, name: Set<AnyHashable>, args: A) {
    self.resolver = resolver
    self.name = name
  }

  public func resolve<A>(args arg1: A = ()) throws -> T {
    let key = Key(T.self, name: name, args: A.self)
    guard let resolver else {
      throw ResolutionError(key: key, reason: .noResolver)
    }
    return try resolver.resolve(T.self, name: name, args: arg1)
  }

  public func resolve<A>(args arg1: A = ()) async throws -> T {
    let key = Key(T.self, name: name, args: A.self)
    guard let resolver else {
      throw ResolutionError(key: key, reason: .noResolver)
    }
    return try await resolver.resolve(T.self, name: name, args: arg1)
  }
}

extension LazyNameResolver: LazyResolving {}
