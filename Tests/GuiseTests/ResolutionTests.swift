//
//  ResolutionTests.swift
//  GuiseTests
//
//  Created by Greg Higley on 2022-09-21.
//

import XCTest
@testable import Guise

final class ResolutionTests: XCTestCase {
  func test_sync_transient() throws {
    // Given
    class Transient {}
    let container = Container()
    container.register(factory: auto(Transient.init))
    
    // Then
    let transient1 = try container.resolve(Transient.self)
    let transient2 = try container.resolve(Transient.self)
    
    // Then
    XCTAssert(transient1 !== transient2)
  }
  
  func test_async_transient() async throws {
    // Given
    class Transient {}
    let container = Container()
    container.register { _ async in
      Transient()
    }
    
    // Then
    let transient1 = try await container.resolve(Transient.self)
    let transient2 = try await container.resolve(Transient.self)
    
    // Then
    XCTAssert(transient1 !== transient2)
  }
  
  func test_sync_singleton() throws {
    // Given
    class Singleton {}
    let container = Container()
    container.register(lifetime: .singleton, instance: Singleton())
    
    // When
    let singleton1 = try container.resolve(Singleton.self)
    let singleton2 = try container.resolve(Singleton.self)
    
    // Then
    XCTAssert(singleton1 === singleton2)
  }
  
  func test_async_singleton() async throws {
    // Given
    class Singleton {}
    let container = Container()
    container.register(lifetime: .singleton) { _ async in
      Singleton()
    }
    
    // When
    let singleton1 = try await container.resolve(Singleton.self)
    let singleton2 = try await container.resolve(Singleton.self)
    
    // Then
    XCTAssert(singleton1 === singleton2)
  }
  
  func test_sync_resolve_async() throws {
    // Given
    class Transient {}
    let container = Container()
    container.register { _ async in
      Transient()
    }
    
    // When/Then
    do {
      _ = try container.resolve(Transient.self)
      XCTFail("Expected to throw a ResolutionError with reason .requiresAsync")
    } catch let error as ResolutionError {
      guard case .requiresAsync = error.reason else {
        throw error
      }
    }
    
    // When
    defer { Entry.allowSynchronousResolutionOfAsyncEntries = false }
    Entry.allowSynchronousResolutionOfAsyncEntries = true
    
    // Then
    _ = try container.resolve(Transient.self)
  }
  
  func test_resolve_optional() throws {
    // Given
    class Service {}
    let container = Container()
    container.register(instance: Service())
    var service: Service?
    
    // When
    service = try container.resolve()
    
    // Then
    XCTAssertNotNil(service)
  }
  
  func test_resolve_lazy() throws {
    // Given
    class Service {}
    let container = Container()
    container.register(instance: Service())
    
    // When
    let lazyResolver = try container.resolve(LazyResolver<Service>.self)
    let service = try? lazyResolver.resolve()
    
    // Then
    XCTAssertNotNil(service)
  }
  
  func test_resolve_lazy_name() throws {
    // Given
    class Service {}
    let container = Container()
    container.register(name: 1, instance: Service())
    
    // When
    let lazyResolver: LazyNameResolver<Service> = try container.resolve(name: 1)
    let service = try? lazyResolver.resolve()
    
    // Then
    XCTAssertNotNil(service)
  }
  
  func test_resolve_lazy_full() throws {
    // Given
    class Service {}
    let container = Container()
    container.register(name: 1, instance: Service())
    
    // When
    let lazyResolver: LazyFullResolver<Service> = try container.resolve(name: 1)
    let service = try? lazyResolver.resolve()
    
    // Then
    XCTAssertNotNil(service)
  }
  
  func test_resolve_all_sync() throws {
    // Given
    class Plugin {}
    let container = Container()
    container.register(name: UUID(), "plugin", instance: Plugin())
    container.register(name: UUID(), "plugin", instance: Plugin())
    
    // When
    let plugins: [Plugin] = try container.resolve(name: "plugin")
    
    // Then
    XCTAssertEqual(plugins.count, 2)
  }
  
  func test_resolve_all_async() async throws {
    // Given
    class Plugin {}
    let container = Container()
    container.register(name: UUID(), "plugin", instance: Plugin())
    container.register(name: UUID(), "plugin", instance: Plugin())
    
    // When
    let plugins = try await container.resolve([Plugin].self, name: "plugin")
    print(plugins)
    
    // Then
    XCTAssertEqual(plugins.count, 2)
  }
}
