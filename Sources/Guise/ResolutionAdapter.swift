//
//  ResolutionAdapter.swift
//  Guise
//
//  Created by Gregory Higley on 2024-11-05.
//

/**
 `ResolutionAdapter` allows dynamic resolution of
 collection and optional types.
 
 At the moment, this is internal to the module because
 in its current form it does not allow nesting. For example,
 one cannot say …
 
 ```swift
 let s: [String]? = try r.resolve()
 ```
 
 There's no need for `[T]?` because there is no
 semantic difference between an empty list `[]` and `nil`. 
 `[T?]` is even more pointless.
 
 In theory, we can imagine a `ResolutionAdapter` that is
 neither an array nor a list and that could be nested,
 but in practice there's little call for such a thing.
 */
protocol ResolutionAdapter {
  static func resolve<each Arg: Sendable>(
    with resolver: any Resolver,
    key: any Keyed,
    args: repeat each Arg
  ) throws -> Any
  static func resolve<each Arg: Sendable>(
    with resolver: any Resolver,
    key: any Keyed,
    args: repeat each Arg
  ) async throws -> Any
  @MainActor
  static func resolve<each Arg: Sendable>(
    with resolver: any Resolver,
    key: any Keyed,
    isolation: MainActor,
    args: repeat each Arg
  ) throws -> Any
}

extension Optional: ResolutionAdapter {
  public static func resolve<each Arg: Sendable>(
    with resolver: any Resolver,
    key: any Keyed,
    args: repeat each Arg
  ) throws -> Any {
    let key = Key<Wrapped>(tagset: key.tagset)
    var result: Wrapped?
    do {
      result = try resolver.resolve(key: key, args: repeat each args)
    } catch let error as ResolutionError {
      guard
        error.key == key,
        case .notFound = error.reason
      else {
        throw error
      }
    }
    return (result as Any)
  }

  public static func resolve<each Arg: Sendable>(
    with resolver: any Resolver,
    key: any Keyed,
    args: repeat each Arg
  ) async throws -> Any {
    let key = Key<Wrapped>(tagset: key.tagset)
    var result: Wrapped?
    do {
      result = try await resolver.resolve(key: key, args: repeat each args)
    } catch let error as ResolutionError {
      guard
        error.key == key,
        case .notFound = error.reason
      else {
        throw error
      }
    }
    return (result as Any)
  }

  @MainActor
  public static func resolve<each Arg: Sendable>(
    with resolver: any Resolver,
    key: any Keyed,
    isolation: MainActor,
    args: repeat each Arg
  ) throws -> Any {
    let key = Key<Wrapped>(tagset: key.tagset)
    var result: Wrapped?
    do {
      result = try resolver.resolve(key: key, isolation: isolation, args: repeat each args)
    } catch let error as ResolutionError {
      guard
        error.key == key,
        case .notFound = error.reason
      else {
        throw error
      }
    }
    return (result as Any)
  }
}

extension Array: ResolutionAdapter {
  public static func resolve<each Arg: Sendable>(
    with resolver: any Resolver,
    key: any Keyed,
    args: repeat each Arg
  ) throws -> Any {
    var result: [Element] = []
    let criteria = Criteria<Element>(op: .subset, tagset: key.tagset)
    for key in resolver.find(criteria) {
      try result.append(resolver.resolve(key: key, args: repeat each args))
    }
    return result
  }

  public static func resolve<each Arg: Sendable>(
    with resolver: any Resolver,
    key: any Keyed,
    args: repeat each Arg
  ) async throws -> Any {
    var result: [Element] = []
    let criteria = Criteria<Element>(op: .subset, tagset: key.tagset)
    for key in resolver.find(criteria) {
      try await result.append(resolver.resolve(key: key, args: repeat each args))
    }
    return result
  }

  @MainActor
  public static func resolve<each Arg: Sendable>(
    with resolver: any Resolver,
    key: any Keyed,
    isolation: MainActor,
    args: repeat each Arg
  ) throws -> Any {
    var result: [Element] = []
    let criteria = Criteria<Element>(op: .subset, tagset: key.tagset)
    for key in resolver.find(criteria) {
      try result.append(resolver.resolve(key: key, isolation: isolation, args: repeat each args))
    }
    return result
  }
}

extension Set: ResolutionAdapter {
  public static func resolve<each Arg: Sendable>(
    with resolver: any Resolver,
    key: any Keyed,
    args: repeat each Arg
  ) throws -> Any {
    var result: Set<Element> = []
    let criteria = Criteria<Element>(op: .subset, tagset: key.tagset)
    for key in resolver.find(criteria) {
      try result.insert(resolver.resolve(key: key, args: repeat each args))
    }
    return result
  }

  public static func resolve<each Arg: Sendable>(
    with resolver: any Resolver,
    key: any Keyed,
    args: repeat each Arg
  ) async throws -> Any {
    var result: Set<Element> = []
    let criteria = Criteria<Element>(op: .subset, tagset: key.tagset)
    for key in resolver.find(criteria) {
      try await result.insert(resolver.resolve(key: key, args: repeat each args))
    }
    return result
  }

  @MainActor
  public static func resolve<each Arg: Sendable>(
    with resolver: any Resolver,
    key: any Keyed,
    isolation: MainActor,
    args: repeat each Arg
  ) throws -> Any {
    var result: Set<Element> = []
    let criteria = Criteria<Element>(op: .subset, tagset: key.tagset)
    for key in resolver.find(criteria) {
      try result.insert(resolver.resolve(key: key, isolation: isolation, args: repeat each args))
    }
    return result
  }
}
