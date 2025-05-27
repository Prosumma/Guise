//
//  EntryTests.swift
//  Guise
//
//  Created by Gregory Higley on 2024-12-18.
//

import Guise
import Testing

@Test func testEntry_invalidArgsType() throws {
  let container = Container()
  container.register(instance: Thing(x: 12))
  let key = Key<Thing>()
  do {
    _ = try container.resolve(Thing.self, args: "bob")
    Issue.record("We should not have resolved a Thing here.")
  } catch let error as ResolutionError {
    guard
      error.key == key,
      case .invalidArgsType = error.reason
    else {
      throw error
    }
  }
}

@Test func testEntry_invalidArgsType_async() async throws {
  let container = Container()
  container.register(lifetime: .singleton) { _ in await Alien(s: "bob") }
  let key = Key<Alien>()
  do {
    _ = try await container.resolve(Alien.self, args: 2)
    Issue.record("We should not have resolved an Alien here.")
  } catch let error as ResolutionError {
    guard
      error.key == key,
      case .invalidArgsType = error.reason
    else {
      throw error
    }
  }
}

@Test @MainActor func testEntry_invalidArgsType_main() throws {
  let container = Container()
  container.register(isolation: #isolation, instance: Thing(x: 12))
  let key = Key<Thing>()
  do {
    _ = try container.resolve(Thing.self, isolation: #isolation, args: "bob")
    Issue.record("We should not have resolved a Thing here.")
  } catch let error as ResolutionError {
    guard
      error.key == key,
      case .invalidArgsType = error.reason
    else {
      throw error
    }
  }
}

@Test func testEntry_requiresAsync() throws {
  let container = Container()
  container.register(lifetime: .singleton) { _ in await Alien(s: "bob") }
  let key = Key<Alien>()
  do {
    _ = try container.resolve(Alien.self, args: 2)
    Issue.record("We should not have resolved an Alien here.")
  } catch let error as ResolutionError {
    guard
      error.key == key,
      case .requiresAsync = error.reason
    else {
      throw error
    }
  }
}

@Test @MainActor func testEntry_requiresAsync_main() throws {
  let container = Container()
  container.register(lifetime: .singleton) { _ in await Alien(s: "bob") }
  let key = Key<Alien>()
  do {
    _ = try container.resolve(Alien.self, isolation: #isolation, args: 2)
    Issue.record("We should not have resolved an Alien here.")
  } catch let error as ResolutionError {
    guard
      error.key == key,
      case .requiresAsync = error.reason
    else {
      throw error
    }
  }
}

@Test func testEntry_requiresMain() throws {
  let container = Container()
  container.register(Thing.self, isolation: MainActor.shared) { _ in
    Thing(x: 14)
  }
  let key = Key<Thing>()
  do {
    _ = try container.resolve(Thing.self)
    Issue.record("We should not have resolved a Thing here.")
  } catch let error as ResolutionError {
    guard
      error.key == key,
      case .requiresMainActor = error.reason
    else {
      throw error
    }
  }
}

@Test func testEntry_singleton() async throws {
  let container = Container()
  container.register(lifetime: .singleton, factory: auto(Ningleton.init))
  let task1 = Task {
    try await container.resolve(Ningleton.self)
  }
  let task2 = Task {
    try await container.resolve(Ningleton.self)
  }
  #expect(try await task1.value === task2.value)
}

@Test func testEntry_singletonSameInstance() throws {
  let container = Container()
  container.register(lifetime: .singleton, factory: auto(Ningleton.init))
  let ningleton1: Ningleton = try container.resolve()
  let ningleton2: Ningleton = try container.resolve()
  #expect(ningleton1 === ningleton2)
}

@Test func testEntry_singletonAsync() async throws {
  let container = Container()
  container.register(lifetime: .singleton, factory: auto(Singleton.init))
  let task1 = Task {
    try await container.resolve(Singleton.self)
  }
  let task2 = Task {
    try await container.resolve(Singleton.self)
  }
  #expect(try await task1.value === task2.value)
  let singleton: Singleton = try await container.resolve()
  #expect(try await task2.value === singleton)
}

@Test @MainActor func testEntry_singletonSameInstance_main() throws {
  let container = Container()
  container.register(lifetime: .singleton, isolation: #isolation, factory: auto(Ningleton.init))
  let ningleton1: Ningleton = try container.resolve(isolation: #isolation)
  let ningleton2: Ningleton = try container.resolve(isolation: #isolation)
  #expect(ningleton1 === ningleton2)
}

@Test func testEntry_singletonAsync_main() async throws {
  let container = Container()
  container.register(lifetime: .singleton, isolation: MainActor.shared) { _ in
    Ningleton()
  }
  let task1 = Task {
    try await container.resolve(Ningleton.self)
  }
  let task2 = Task {
    try await container.resolve(Ningleton.self)
  }
  #expect(try await task1.value === task2.value)
}
