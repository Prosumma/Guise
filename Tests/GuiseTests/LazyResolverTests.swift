//
//  LazyResolverTests.swift
//  Guise
//
//  Created by Gregory Higley on 2024-12-18.
//

import Testing

@testable import Guise

@Test func testLazyResolver_resolveAsync() async throws {
  let container = Container()
  container.register(factory: { (_, arg) in Thing(x: arg) })
  let lazyThing: LazyResolver<Thing> = try await container.resolve()
  let thing = try await lazyThing.resolve(args: 47)
  #expect(thing.x == 47)
}

@Test func testLazyResolver_resolveSync() throws {
  let container = Container()
  container.register(factory: { (_, arg) in Thing(x: arg) })
  let lazyThing: LazyResolver<Thing> = try container.resolve()
  let thing = try lazyThing.resolve(args: 47)
  #expect(thing.x == 47)
}

@Test func testLazyResolver_resolveAsync_withoutResolver() async throws {
  var container: Container? = Container()
  container?.register(factory: { (_, arg) in Thing(x: arg) })
  let lazyThing: LazyResolver<Thing> = try await container!.resolve()
  container = nil
  let key = Key<Thing>()
  do {
    _ = try await lazyThing.resolve(args: 47)
    Issue.record("We should not be able to resolve a Thing here.")
  } catch let error as ResolutionError {
    guard
      error.key == key,
      case .noResolver = error.reason
    else {
      throw error
    }
  }
}

@Test func testLazyResolver_resolveSync_withoutResolver() throws {
  var container: Container? = Container()
  let lazyThing = LazyResolver<Thing>(tags: 47, with: container!)
  container = nil
  let key = Key<Thing>(tags: 47)
  do {
    _ = try lazyThing.resolve(args: 47)
    Issue.record("We should not be able to resolve a Thing here.")
  } catch let error as ResolutionError {
    guard
      error.key == key,
      case .noResolver = error.reason
    else {
      throw error
    }
  }
}

@Test func testLazyResolver_withArrayResolutionAdapter() throws {
  let container = Container()
  container.register(instance: Thing(x: 3))
  let lazyThingsResolver: LazyResolver<[Thing]> = try container.resolve()
  let things = try lazyThingsResolver.resolve()
  #expect(things.count == 1)
}

@Test func testLazyResolver_withOptionalResolutionAdapter() throws {
  let container = Container()
  container.register(instance: Thing(x: 3))
  let lazyThingResolver: LazyResolver<Thing?> = try container.resolve()
  let thing = try lazyThingResolver.resolve()
  #expect(thing?.x == 3)
}
