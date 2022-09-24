//
//  EntryTests.swift
//  GuiseTests
//
//  Created by Gregory Higley on 2022-09-24.
//

import XCTest
@testable import Guise

/**
 There are twelve basic tests that must be performed, based
 on the following matrix:
 
 - `resolve`: whether the call to `resolve` is `sync` or `async`.
 - `resolution`: whether `resolution` is `instance` or `factory`.
 - `factory`: whether `factory` is `sync` or `async`.
 - `lifetime`: whether `lifetime` is `transient` or `singleton`.
 - whether synchronous resolution of async factories is allowed or not.

 Not all of these combinations are logically possible, which is why there
 are only twelve tests.
 
 The names of the tests are a bit cryptic, but make sense by reference
 to the matrix:
 
 `test_sync_factory_async_transient`
 
 This tests the situation where `resolve` is called synchronously, `resolution`
 is `factory`, the `factory` is `async` and the `lifetime` is `transient`.
 
 In fact, when `resolve` is `sync` and the factory is `async`, we have to
 do two tests: One where synchronous evaluation of `async` factories is allowed
 and another where it isn't. By default it isn't allowed, so in the situation
 where it is, we add `_allowed` to the end:
 
 `test_sync_factory_async_transient_allowed`
 
 In addition to the basic tests, there are tests for race conditions.
 */
final class EntryTests: XCTestCase {
  var container: Container!
  
  override func setUp() {
    super.setUp()
    container = Container()
    prepareForGuiseTests()
  }
  
  func test_sync_instance() throws {
    // Given
    container.register(lifetime: .singleton, instance: Service())
    
    // When
    let service1: Service = try container.resolve()
    let service2: Service = try container.resolve()
    
    // Then
    XCTAssert(service1 === service2)
  }
  
  func test_sync_factory_sync_singleton() throws {
    // Given
    container.register(lifetime: .singleton, instance: Service())

    // When
    let service1 = try container.resolve(Service.self)
    let service2 = try container.resolve(Service.self)
    
    // Then
    XCTAssert(service1 === service2)
  }
  
  func test_sync_factory_sync_transient() throws {
    // Given
    container.register(factory: auto(Service.init))
    
    // When/Then
    _ = try container.resolve(Service.self)
  }
  
  func test_sync_factory_async_singleton() throws {
    // Given
    container.register(lifetime: .singleton) { _ async in
      Service()
    }
    
    // When/Then
    do {
      _ = try container.resolve(Service.self)
      XCTFail("Expected to throw .requiresAsync.")
    } catch let error as ResolutionError {
      let key = Key(Service.self)
      guard
        error.key == key,
        case .requiresAsync = error.reason
      else {
        throw error
      }
    }
  }
  
  func test_sync_factory_async_singleton_allowed() throws {
    // Given
    container.register(lifetime: .singleton) { _ async in
      Service()
    }
    Entry.allowSynchronousResolutionOfAsyncEntries = true
    
    // When/Then
    _ = try container.resolve(Service.self)
  }
  
  func test_sync_factory_async_transient() throws {
    // Given
    container.register { _ async in
      Service()
    }
    
    // When/Then
    do {
      _ = try container.resolve(Service.self)
      XCTFail("Expected to throw .requiresAsync.")
    } catch let error as ResolutionError {
      let key = Key(Service.self)
      guard
        error.key == key,
        case .requiresAsync = error.reason
      else {
        throw error
      }
    }
  }
  
  func test_sync_factory_async_transient_allowed() throws {
    // Given
    container.register { _ async in
      Service()
    }
    Entry.allowSynchronousResolutionOfAsyncEntries = true
    
    // When/Then
    _ = try container.resolve(Service.self)
  }
  
  func test_async_instance() async throws {
    // Given
    container.register(lifetime: .singleton) { _ async in
      Service()
    }
    
    // When
    let service1: Service = try await container.resolve()
    let service2: Service = try await container.resolve()
    
    // Then
    XCTAssert(service1 === service2)
  }

  func test_async_factory_sync_singleton() async throws {
    // Given
    container.register(lifetime: .singleton, factory: auto(Service.init))
    
    // When/Then
    _ = try await container.resolve(Service.self)
  }
  
  func test_async_factory_sync_transient() async throws {
    // Given
    container.register(factory: auto(Service.init))
    
    // When/Then
    _ = try await container.resolve(Service.self)
  }
  
  func test_async_factory_async_singleton() async throws {
    // Given
    container.register(lifetime: .singleton) { _ async in
      Service()
    }
    
    // When
    let service1: Service = try await container.resolve()
    let service2: Service = try await container.resolve()
    
    // Then
    XCTAssert(service1 === service2)
  }
  
  func test_async_factory_async_transient() async throws {
    // Given
    container.register { _ async in
        Service()
    }
    
    // When/Then
    _ = try await container.resolve(Service.self)
  }

  func test_sync_race() {
    // Given
    container.register(lifetime: .singleton, instance: Service())
    Entry.singletonTestDelay = 100_000
    let semaphore = DispatchSemaphore(value: 0)
    var service1: Service?
    var service2: Service?
    
    // When
    Thread.detachNewThread {
      service1 = try? self.container.resolve(Service.self)
      semaphore.signal()
    }

    Thread.detachNewThread {
      service2 = try? self.container.resolve(Service.self)
      semaphore.signal()
    }
    
    semaphore.wait()
    semaphore.wait()
    
    // Then
    XCTAssertNotNil(service1)
    XCTAssert(service1 === service2)
  }
  
  func test_async_race() async throws {
    // Given
    container.register(lifetime: .singleton) { _ async in
      Service()
    }
    Entry.singletonTestDelay = 100_000
    async let service1 = container.resolve(Service.self)
    async let service2 = container.resolve(Service.self)
    
    // When
    let services = try await [service1, service2]
    
    // Then
    XCTAssert(services[0] === services[1])
  }
}

extension EntryTests {
  class Service {}
}
