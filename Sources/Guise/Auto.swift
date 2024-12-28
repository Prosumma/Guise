//
//  Auto.swift
//  Guise
//
//  Created by Gregory Higley on 2024-11-07.
//

/// Automatically initializes a dependency of type `T` using the provided dependencies.
/// 
/// This is used in the `factory` parameter of the various `register` overloads.
///
/// - Parameters:
///   - T: The type of the dependency to resolve.
///   - Dep: The types of the dependencies to use for resolution.
/// - Returns: An instance of type `T` resolved using the provided dependencies.
public func auto<T, each Dep>(
  _ initializer: @escaping (repeat each Dep) throws -> T
) -> (any Resolver) throws -> T {
  return { resolver in
    try initializer(repeat resolver.resolve() as (each Dep))
  }
}

/// Automatically initializes a dependency of type `T` with the given dependencies.
/// 
/// This is used in the `factory` parameter of the various `register` overloads.
///
/// - Parameters:
///   - T: The type of the dependency to resolve.
///   - Dep: The types of the dependencies required to resolve `T`.
/// - Returns: An instance of type `T`.
/// - Throws: An error if the dependency cannot be resolved.
public func auto<T, each Dep>(
  _ initializer: @escaping (repeat each Dep) async throws -> T
) -> (any Resolver) async throws -> T {
  return { resolver in
    try await initializer(repeat resolver.resolve() as (each Dep))
  }
}
