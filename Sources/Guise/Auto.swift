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
  _ initializer: @escaping @Sendable (repeat each Dep) throws -> T
) -> @Sendable (any Resolver) throws -> T {
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
  _ initializer: @escaping @Sendable (repeat each Dep) async throws -> T
) -> @Sendable (any Resolver) async throws -> T {
  return { resolver in
    try await initializer(repeat resolver.resolve() as (each Dep))
  }
}

/// Automatically initializes a dependency of type `T` using the provided dependencies.
/// This particular version must be used when registering a MainActor-isolated type.
/// 
/// This is used in the `factory` parameter of the various `register` overloads.
///
/// - Parameters:
///   - T: The type of the dependency to resolve.
///   - Dep: The types of the dependencies to use for resolution.
/// - Returns: An instance of type `T` resolved using the provided dependencies.
public func mainauto<T: Sendable, each Dep>(
  _ initializer: @escaping @MainActor @Sendable (repeat each Dep) throws -> T
) -> @MainActor @Sendable (any Resolver) throws -> T {
  return { resolver in
    try initializer(repeat resolver.resolve(isolation: MainActor.shared) as (each Dep))
  }
}
