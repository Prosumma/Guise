//
//  LazyFullResolverTests.swift
//  GuiseTests
//
//  Created by Gregory Higley on 2022-09-24.
//

import XCTest
@testable import Guise

final class LazyFullResolverTests: XCTestCase {

  override func setUp() {
    super.setUp()
    prepareForGuiseTests()
  }

  func test_resolve_sync() throws {
    // Given
    let container = Container()
    container.register(name: 42, instance: Service())
    let lfr: LazyFullResolver<Service> = try container.resolve(name: 42)

    // When/Then
    _ = try lfr.resolve()
  }

  func test_resolve_sync_weak() throws {
    // Given
    var container: Container? = Container()
    container!.register(instance: Service())
    let lfr: LazyFullResolver<Service> = try container!.resolve()

    // When
    container = nil

    // Then
    do {
      _ = try lfr.resolve()
      XCTFail("Expected resolution to fail.")
    } catch let error as ResolutionError {
      let key = Key(Service.self)
      guard
        error.key == key,
        case .noResolver = error.reason
      else {
        throw error
      }
    }
  }

  func test_resolve_async() async throws {
    // Given
    let container = Container()
    container.register(name: 42) { _ async in
      Service()
    }
    let lfr: LazyFullResolver<Service> = try await container.resolve(name: 42)

    // When/Then
    _ = try await lfr.resolve()
  }

  func test_resolve_async_weak() async throws {
    // Given
    var container: Container? = Container()
    container!.register { _ async in
      Service()
    }
    let lfr: LazyFullResolver<Service> = try await container!.resolve()

    // When
    container = nil

    // Then
    do {
      _ = try await lfr.resolve()
      XCTFail("Expected resolution to fail.")
    } catch let error as ResolutionError {
      let key = Key(Service.self)
      guard
        error.key == key,
        case .noResolver = error.reason
      else {
        throw error
      }
    }
  }
}

extension LazyFullResolverTests {
  class Service {}
}
