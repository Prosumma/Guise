//
//  ResolutionAdapterTests.swift
//  Guise
//
//  Created by Gregory Higley on 2024-12-18.
//

import Guise
import Testing

@Test func testResolveArray() throws {
  let container = Container()
  container.register(tags: 7, instance: Thing(x: 7))
  container.register(tags: 6, instance: Thing(x: 6))
  let things: [Thing] = try container.resolve()
  #expect(things.count == 2)
}

@Test func testResolveArray_notFound() throws {
  let container = Container()
  let things: [Thing] = try container.resolve()
  #expect(things.isEmpty)
}

@Test func testResolveArray_async() async throws {
  let container = Container()
  container.register(tags: 7, instance: Thing(x: 7))
  container.register(tags: 6, instance: Thing(x: 6))
  let things: [Thing] = try await container.resolve()
  #expect(things.count == 2)
}

@Test func testResolveArray_notFound_async() async throws {
  let container = Container()
  let things: [Thing] = try await container.resolve()
  #expect(things.isEmpty)
}

@Test @MainActor func testResolveArray_main() throws {
  let container = Container()
  container.register(isolation: #isolation, tags: 7, instance: Thing(x: 7))
  container.register(isolation: #isolation, tags: 6, instance: Thing(x: 6))
  let things: [Thing] = try container.resolve(isolation: #isolation)
  #expect(things.count == 2)
}

@Test func testResolveSet() throws {
  let container = Container()
  container.register(tags: 7, instance: 7)
  container.register(tags: 6, instance: 6)
  let ints: Set<Int> = try container.resolve()
  #expect(ints.count == 2)
}

@Test func testResolveSet_notFound() throws {
  let container = Container()
  let ints: Set<Int> = try container.resolve()
  #expect(ints.isEmpty)
}

@Test func testResolveSet_async() async throws {
  let container = Container()
  container.register(tags: 7, instance: 7)
  container.register(tags: 6, instance: 6)
  let ints: Set<Int> = try await container.resolve()
  #expect(ints.count == 2)
}

@Test func testResolveSet_notFound_async() async throws {
  let container = Container()
  let ints: Set<Int> = try await container.resolve()
  #expect(ints.isEmpty)
}

@Test @MainActor func testResolveSet_main() throws {
  let container = Container()
  container.register(isolation: #isolation, tags: 7, instance: 7)
  container.register(isolation: #isolation, tags: 6, instance: 6)
  let ints: Set<Int> = try container.resolve(isolation: #isolation)
  #expect(ints.count == 2)
}

@Test func testResolveOptional() throws {
  let container = Container()
  container.register(instance: Thing(x: 99))
  let thing: Thing? = try container.resolve()
  #expect(thing?.x == 99)
}

@Test func testResolveOptional_async() async throws {
  let container = Container()
  container.register(instance: Thing(x: 99))
  let thing: Thing? = try await container.resolve()
  #expect(thing?.x == 99)
}

@Test @MainActor func testResolveOptional_main() throws {
  let container = Container()
  container.register(isolation: MainActor.shared, instance: Thing(x: 99))
  let thing: Thing? = try container.resolve(isolation: MainActor.shared)
  #expect(thing?.x == 99)
}

@Test func testResolveOptional_throwError() throws {
  let container = Container()
  container.register(Int.self) { _ in throw ResolutionError(Key<Int>(), reason: .noResolver) }
  do {
    _ = try container.resolve(Int?.self)
    Issue.record("We should not have resolved an Int here.")
  } catch {
    // This is what we want
  }
}

@Test func testResolveOptional_throwError_async() async throws {
  let container = Container()
  container.register(Int.self) { _ in throw ResolutionError(Key<Int>(), reason: .noResolver) }
  do {
    _ = try await container.resolve(Int?.self)
    Issue.record("We should not have resolved an Int here.")
  } catch {
    // This is what we want
  }
}

@Test @MainActor func testResolveOptional_throwError_main() throws {
  let container = Container()
  container.register(Int.self, isolation: MainActor.shared) { _ in
    throw ResolutionError(Key<Int>(), reason: .noResolver)
  }
  do {
    _ = try container.resolve(Int?.self, isolation: MainActor.shared)
    Issue.record("We should not have resolved an Int here.")
  } catch {
    // This is what we want
  }
}
