//
//  LazyNameResolver.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

import Foundation

/**
 A lazy resolver which stores `tags` for later use
 when it is resolved.
 
 To instantiate a `LazyNameResolver`, use the `Resolver`
 itself:
 
 ```swift
 let ltr: LazyNameResolver<Service> = try resolver.resolve(tags: "s")
 ```
 
 Any tags passed during resolution is stored by the `LazyNameResolver`
 to be used when resolving with it:
 
 ```swift
 let service = try ltr.resolve()
 ```
 
 This implicitly uses the tags "s" when resolving.
 
 Any arguments passed when constructing the `LazyTagsResolver` are
 ignored and must be passed when resolving:
 
 ```
 let service = try ltr.resolve(args: 1)
 ```
 */
public final class LazyTagsResolver<T> {
  private weak var resolver: (any Resolver)?
  public let tags: Set<AnyHashable>

  init<A>(_ resolver: any Resolver, tags: Set<AnyHashable>, args: A) {
    self.resolver = resolver
    self.tags = tags
  }

  public func resolve<A>(args arg1: A = ()) throws -> T {
    let key = Key(T.self, tags: tags, args: A.self)
    guard let resolver else {
      throw ResolutionError(key: key, reason: .noResolver)
    }
    return try resolver.resolve(T.self, tags: tags, args: arg1)
  }

  public func resolve<A>(args arg1: A = ()) async throws -> T {
    let key = Key(T.self, tags: tags, args: A.self)
    guard let resolver else {
      throw ResolutionError(key: key, reason: .noResolver)
    }
    return try await resolver.resolve(T.self, tags: tags, args: arg1)
  }
}

extension LazyTagsResolver: LazyResolving {}