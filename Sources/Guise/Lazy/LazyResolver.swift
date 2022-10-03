//
//  LazyResolver.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

/**
 A lazy resolver which resolves instances of the type `T`.
 tags and arguments must be specified when resolving.
 
 To instantiate a `LazyResolver`, use the `Resolver` itself:
 
 ```swift
 let lr: LazyResolver<Service> = try resolver.resolve()
 ```
 
 Any `tags` or arguments passed when instantiating a `LazyResolver`
 are ignored. These must be supplied when using the lazy resolver:
 
 ```swift
 let service = try lr.resolve(tags: "s", args: 2)
 ```
 */
public final class LazyResolver<T> {
  weak var resolver: (any Resolver)?

  /**
   This constructor is required to satisfy the `LazyResolving` protocol,
   but the `tags` and `args` arguments are ignored.
   */
  public init<A>(_ resolver: any Resolver, tags: Set<AnyHashable>, args: A) {
    self.resolver = resolver
  }

  public func resolve<A>(tags: Set<AnyHashable>, args arg1: A) throws -> T {
    let key = Key(T.self, tags: tags, args: A.self)
    guard let resolver else {
      throw ResolutionError(key: key, reason: .noResolver)
    }
    return try resolver.resolve(T.self, tags: tags, args: arg1)
  }

  public func resolve<A>(tags: Set<AnyHashable>, args arg1: A) async throws -> T {
    let key = Key(T.self, tags: tags, args: A.self)
    guard let resolver else {
      throw ResolutionError(key: key, reason: .noResolver)
    }
    return try await resolver.resolve(T.self, tags: tags, args: arg1)
  }
}

extension LazyResolver: LazyResolving {}
