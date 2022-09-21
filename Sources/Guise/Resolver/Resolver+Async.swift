//
//  Resolver+Async.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

public extension Resolver {
  func resolve<T, A>(
    _ type: T.Type,
    name: Set<AnyHashable>,
    args arg1: A
  ) async throws -> T {
    let key = Key(type, name: name, args: A.self)
    let entry = try resolve(key: key)
    do {
      return try await entry.resolve(self, arg1) as! T
    } catch let reason as ResolutionError.Reason {
      throw ResolutionError(key: key, reason: reason)
    } catch let error as ResolutionError {
      throw error
    } catch {
      throw ResolutionError(key: key, reason: .error(error))
    }
  }
  
  func resolve<T, A>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    args arg1: A = ()
  ) async throws -> T {
    try await resolve(type, name: Set(name), args: arg1)
  }
  
  func resolve<T, A1, A2>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    args arg1: A1, _ arg2: A2
  ) async throws -> T {
    try await resolve(type, name: Set(name), args: (arg1, arg2))
  }
}
