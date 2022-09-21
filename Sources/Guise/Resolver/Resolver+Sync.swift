//
//  Resolver+Sync.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

extension Resolver {
  /**
   A helper method for resolving an `Entry`.
   
   Never call `Entry::resolve` directly. Instead, use
   this method, which handles error propagation.
   */
  func resolve<T, A>(
    entry: Entry,
    args arg1: A,
    forKey key: Key
  ) throws -> T {
    do {
      return try entry.resolve(self, arg1) as! T
    } catch let reason as ResolutionError.Reason {
      throw ResolutionError(key: key, reason: reason)
    } catch let error as ResolutionError {
      throw error
    } catch {
      throw ResolutionError(key: key, reason: .error(error))
    }
  }
}

public extension Resolver {
  /**
   The root resolution method. All roads lead here.
   
   Although this method is public, its overloads are
   much more convenient to use.
   */
  func resolve<T, A>(
    _ type: T.Type = T.self,
    name: Set<AnyHashable>,
    args arg1: A
  ) throws -> T {
    switch type {
    case let type as LazyResolving.Type:
      return type.init(self, name: name) as! T
    case let type as OptionalResolving.Type:
      return try type.resolve(with: self, name: name, args: arg1) as! T
    default:
      let key = Key(T.self, name: name, args: A.self)
      let entry = try resolve(key: key)
      return try resolve(entry: entry, args: arg1, forKey: key)
    }
  }
  
  func resolve<T, A>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    args arg1: A = ()
  ) throws -> T {
    try resolve(type, name: Set(name), args: arg1)
  }
  
  func resolve<T, A1, A2>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    args arg1: A1, _ arg2: A2
  ) throws -> T {
    try resolve(type, name: Set(name), args: (arg1, arg2))
  }
}
