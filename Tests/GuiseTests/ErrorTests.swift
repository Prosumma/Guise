//
//  ErrorTests.swift
//  GuiseTests
//
//  Created by Gregory Higley on 2022-10-03.
//

import XCTest
@testable import Guise

final class ErrorTests: XCTestCase {
  override func setUp() {
    super.setUp()
    prepareForGuiseTests()
  }

  func test_error_same_key_sync() throws {
    // Given
    let key = Key(String.self)
    let container = Container()
    container.register(instance: "error")
    Entry.testResolutionError = ResolutionError(key: key, reason: .notFound)

    // When
    do {
      _ = try container.resolve(String.self)
      XCTFail("Expected to throw an error.")
    } catch let error as ResolutionError {
      guard
        error.key == key,
        case .notFound = error.reason
      else {
        throw error
      }
    }
  }

  func test_error_different_key_sync() throws {
    // Given
    let key = Key(String.self)
    let container = Container()
    container.register(instance: "error")
    container.register(instance: 7)
    Entry.testResolutionError = ResolutionError(key: key, reason: .notFound)

    // When
    do {
      _ = try container.resolve(Int.self)
      XCTFail("Expected to throw an error.")
    } catch let error as ResolutionError {
      guard
        error.key == Key(Int.self),
        case .error(let nestedError as ResolutionError) = error.reason,
        nestedError.key == Key(String.self),
        case .notFound = nestedError.reason
      else {
        throw error
      }
    }
  }

  func test_arbitrary_error_sync() throws {
    // Given
    enum Foo: Error { case foo }
    let key = Key(String.self)
    let container = Container()
    container.register(instance: "error")
    Entry.testResolutionError = Foo.foo

    do {
      _ = try container.resolve(String.self)
      XCTFail("Expected to throw an error.")
    } catch let error as ResolutionError {
      guard
        error.key == key,
        case .error(Foo.foo) = error.reason
      else {
        throw error
      }
    }
  }

  func test_error_same_key_async() async throws {
    // Given
    let key = Key(String.self)
    let container = Container()
    container.register(instance: "error")
    Entry.testResolutionError = ResolutionError(key: key, reason: .notFound)

    // When
    do {
      _ = try await container.resolve(String.self)
      XCTFail("Expected to throw an error.")
    } catch let error as ResolutionError {
      guard
        error.key == key,
        case .notFound = error.reason
      else {
        throw error
      }
    }
  }

  func test_error_different_key_async() async throws {
    // Given
    let key = Key(String.self)
    let container = Container()
    container.register(instance: "error")
    container.register(instance: 7)
    Entry.testResolutionError = ResolutionError(key: key, reason: .notFound)

    // When
    do {
      _ = try await container.resolve(Int.self)
      XCTFail("Expected to throw an error.")
    } catch let error as ResolutionError {
      guard
        error.key == Key(Int.self),
        case .error(let nestedError as ResolutionError) = error.reason,
        nestedError.key == Key(String.self),
        case .notFound = nestedError.reason
      else {
        throw error
      }
    }
  }

  func test_arbitrary_error_async() async throws {
    // Given
    enum Foo: Error { case foo }
    let key = Key(String.self)
    let container = Container()
    container.register(instance: "error")
    Entry.testResolutionError = Foo.foo

    do {
      _ = try await container.resolve(String.self)
      XCTFail("Expected to throw an error.")
    } catch let error as ResolutionError {
      guard
        error.key == key,
        case .error(Foo.foo) = error.reason
      else {
        throw error
      }
    }
  }
}
