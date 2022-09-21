//
//  Entry.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

import Foundation

public class Entry {
  private lazy var lock = DispatchQueue(label: "Guise Entry")
  private lazy var asyncLock = AsyncLock()
  private let factory: Factory
  private let lifetime: Lifetime
  private var resolution: Resolution = .factory
 
  init<T, A>(
    lifetime: Lifetime,
    factory: @escaping (any Resolver, A) throws -> T
  ) {
    self.lifetime = lifetime
    self.factory = .sync { resolver, arg in
      try factory(resolver, arg as! A)
    }
  }
  
  init<T, A>(
    lifetime: Lifetime,
    factory: @escaping (any Resolver, A) async throws -> T
  ) {
    self.lifetime = lifetime
    self.factory = .async { resolver, arg in
      try await factory(resolver, arg as! A)
    }
  }
  
  func resolve(_ resolver: any Resolver, _ argument: Any) throws -> Any {
    switch resolution {
    case .instance(let instance):
      return instance
    case .factory:
      switch lifetime {
      case .transient:
        return try factory(resolver, argument)
      case .singleton:
        return try lock.sync {
          switch resolution {
          case .instance(let instance):
            return instance
          case .factory:
            let instance = try factory(resolver, argument)
            self.resolution = .instance(instance)
            return instance
          }
        }
      }
    }
  }
  
  func resolve(_ resolver: any Resolver, _ argument: Any) async throws -> Any {
    switch resolution {
    case .instance(let instance):
      return instance
    case .factory:
      switch lifetime {
      case .transient:
        return try await factory(resolver, argument)
      case .singleton:
        return try await asyncLock.lock {
          switch resolution {
          case .instance(let instance):
            return instance
          case .factory:
            let instance = try await factory(resolver, argument)
            self.resolution = .instance(instance)
            return instance
          }
        }
      }
    }
  }
}

private extension Entry {
  enum Factory {
    case sync((any Resolver, Any) throws -> Any)
    case `async`((any Resolver, Any) async throws -> Any)
    
    func callAsFunction(_ resolver: any Resolver, _ arg: Any) throws -> Any {
      switch self {
      case .sync(let factory):
        do {
          return try factory(resolver, arg)
        } catch {
          throw ResolutionError.Reason.error(error)
        }
      case .async:
        throw ResolutionError.Reason.requiresAsync
      }
    }
  
    func callAsFunction(_ resolver: any Resolver, _ arg: Any) async throws -> Any {
      do {
        switch self {
        case .sync(let factory):
          return try factory(resolver, arg)
        case .async(let factory):
          return try await factory(resolver, arg)
        }
      } catch {
        throw ResolutionError.Reason.error(error)
      }
    }
  }
  
  enum Resolution {
    case instance(Any)
    case factory
  }
}
