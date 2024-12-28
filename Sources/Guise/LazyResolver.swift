//
//  LazyResolver.swift
//  Guise
//
//  Created by Gregory Higley on 2024-11-07.
//

public final class LazyResolver<T>: LazyResolving {
  public let key: Key<T>
  private weak var resolver: (any Resolver)?

  public init(tagset: Set<AnySendableHashable>, with resolver: any Resolver) {
    self.key = Key(tagset: tagset)
    self.resolver = resolver
  }

  public convenience init<each Tag: Sendable & Hashable>(tags: repeat each Tag, with resolver: any Resolver) {
    let tagset = Set(elements: repeat each tags)
    self.init(tagset: tagset, with: resolver)
  }

  public func resolve<each Arg>(args: repeat each Arg) throws -> T {
    guard let resolver = resolver else {
      throw ResolutionError(key, reason: .noResolver)
    }
    return try resolver.resolve(key: key, args: repeat each args)
  }

  public func resolve<each Arg>(args: repeat each Arg) async throws -> T {
    guard let resolver = resolver else {
      throw ResolutionError(key, reason: .noResolver)
    }
    return try await resolver.resolve(key: key, args: repeat each args)
  }
}
