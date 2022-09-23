//
//  OptionalTests.swift
//  
//
//  Created by Greg Higley on 9/22/22.
//

import XCTest
@testable import Guise

final class OptionalTests: XCTestCase {
  var container: Container!
  
  override func setUp() {
    super.setUp()
    container = Container()
    prepareForGuiseTests()
  }
  
  func test_resolve_sync() throws {
    // Given
    container.register(instance: Service())
    var service: Service?
    
    // When
    service = try container.resolve()
    
    // Then
    XCTAssertNotNil(service)
  }
  
  func test_throw_whenNotFound_sync() throws {
    // Given
    OptionalResolutionConfig.throwResolutionErrorWhenNotFound = true
    var service: Service?
    
    // When
    do {
      service = try container.resolve()
      XCTFail("Expected to throw .notFound")
    } catch let error as ResolutionError {
      let key = Key(Service.self)
      guard
        error.key == key,
        case .notFound = error.reason
      else {
        throw error
      }
    }
    
    // Then
    XCTAssertNil(service)
  }
}

extension OptionalTests {
  class Service {}
}
