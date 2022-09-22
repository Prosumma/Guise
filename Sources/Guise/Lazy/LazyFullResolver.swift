//
//  LazyFullResolver.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

/**
 A lazy resolver which resolves the type `T` with the
 given `name` and arguments.
 
 To construct a `LazyFullResolver`, use the `Resolver` itself:
 
 ```swift
 let lfr: LazyFullResolver<Service> = try resolver.resolve(name: "s", args: 3)
 ```
 
 The `name` and `args` are stored for later use when resolving:
 
 ```
 let service = try lfr.resolve()
 ```
 
 - Warning: This type holds a strong reference to the arguments,
 which could cause a retain cycle in some circumstances. Use with care.
 */
public final class LazyFullResolver<T> {
  // This is a very thunky class.
  
  private let syncResolve: () throws -> T
  private let asyncResolve: () async throws -> T
  
  init<A>(_ resolver: any Resolver, name: Set<AnyHashable>, args: A) {
    let key = Key(T.self, name: name, args: A.self)
    self.syncResolve = { [weak resolver] in
      guard let resolver else {
        throw ResolutionError(key: key, reason: .noResolver)
      }
      return try resolver.resolve(name: name, args: args)
    }
    self.asyncResolve = { [weak resolver] in
      guard let resolver else {
        throw ResolutionError(key: key, reason: .noResolver)
      }
      return try await resolver.resolve(name: name, args: args)
    }
  }
  
  public func resolve() throws -> T {
    try syncResolve()
  }
  
  public func resolve() async throws -> T {
    try await asyncResolve()
  }
}

extension LazyFullResolver: LazyResolving {}
