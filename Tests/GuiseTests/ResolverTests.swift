//
//  ResolverTests.swift
//  Guise
//
//  Created by Gregory Higley on 2024-12-18.
//

import Guise
import Testing

@Test func testResolver_main_async() async throws {
  let container = Container()
  await MainActor.run {
    _ = container.register(isolation: #isolation, instance: Thing(x: 3))
    _ = container.register(isolation: #isolation, factory: mainauto(ViewController.init))
  }
  _ = try await container.resolve(ViewController.self)
}

@Test func testResolver_main_async_singleton() async throws {
  let container = Container()
  await MainActor.run {
    _ = container.register(lifetime: .singleton, instance: Thing(x: 3))
    _ = container.register(lifetime: .singleton, isolation: #isolation, factory: mainauto(ViewController.init))
  }
  _ = try await container.resolve(ViewController.self)
}

@Test func testResolver_notFound() throws {
  let container = Container()
  let key = Key<Int>()
  do {
    _ = try container.resolve(Int.self)
    Issue.record("We should not have resolved anything here.")
  } catch let error as ResolutionError {
    guard
      error.key == key,
      case .notFound = error.reason
    else {
      throw error
    }
  }
}

@Test func testResolver_notFound_async() async throws {
  let container = Container()
  let key = Key<Int>()
  do {
    _ = try await container.resolve(Int.self)
    Issue.record("We should not have resolved anything here.")
  } catch let error as ResolutionError {
    guard
      error.key == key,
      case .notFound = error.reason
    else {
      throw error
    }
  }
}

@Test @MainActor func testResolver_notFound_main() throws {
  let container = Container()
  let key = Key<Int>()
  do {
    _ = try container.resolve(Int.self, isolation: MainActor.shared)
    Issue.record("We should not have resolved anything here.")
  } catch let error as ResolutionError {
    guard
      error.key == key,
      case .notFound = error.reason
    else {
      throw error
    }
  }
}
