//
//  ResolverTests.swift
//  Guise
//
//  Created by Gregory Higley on 2024-12-18.
//

import Guise
import Testing

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
