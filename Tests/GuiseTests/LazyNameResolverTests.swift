//
//  LazyNameResolverTests.swift
//  GuiseTests
//
//  Created by Gregory Higley on 2022-09-24.
//

import XCTest
@testable import Guise

final class LazyNameResolverTests: XCTestCase {
  override func setUp() {
    super.setUp()
    prepareForGuiseTests()
  }
  
  func test_resolve_sync() throws {
    // Given
    let container = Container()
    container.register(name: "s") { _, arg in
      Service(i: arg)
    }
    
    // When
    let lnr: LazyNameResolver<Service> = try container.resolve(name: "s")
    
    // Then
    _ = try lnr.resolve(args: 2)
  }
  
  func test_resolve_sync_weak() throws {
    // Given
    var container: Container? = Container()
    container!.register(name: "s") { _, arg in
      Service(i: arg)
    }
    let lnr: LazyNameResolver<Service> = try container!.resolve(name: "s")
    
    // When
    container = nil
    
    // Then
    do {
      _ = try lnr.resolve(args: 7)
      XCTFail("Expected resolution to fail.")
    } catch let error as ResolutionError {
      let key = Key(Service.self, name: "s", args: Int.self)
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
    container.register(name: "s") { _, arg in
      Service(i: arg)
    }
    
    // When
    let lnr: LazyNameResolver<Service> = try await container.resolve(name: "s")
    
    // Then
    _ = try await lnr.resolve(args: 2)
  }
  
  func test_resolve_async_weak() async throws {
    // Given
    var container: Container? = Container()
    container!.register(name: "s") { _, arg async in
      Service(i: arg)
    }
    let lnr: LazyNameResolver<Service> = try await container!.resolve(name: "s")
    
    // When
    container = nil
    
    // Then
    do {
      _ = try await lnr.resolve(args: 7)
      XCTFail("Expected resolution to fail.")
    } catch let error as ResolutionError {
      let key = Key(Service.self, name: "s", args: Int.self)
      guard
        error.key == key,
        case .noResolver = error.reason
      else {
        throw error
      }
    }
  }
}

extension LazyNameResolverTests {
  class Service {
    let i: Int
    init(i: Int) {
      self.i = i
    }
  }
}
