//
//  ArrayTests.swift
//  GuiseTests
//
//  Created by Gregory Higley 2022-09-24.
//

import XCTest
@testable import Guise

class ArrayTests: XCTestCase {
  var container: Container!

  override func setUp() {
    super.setUp()
    container = Container()
    prepareForGuiseTests()
  }
  
  func test_resolve_sync() throws {
    // Given
    container.register(name: UUID(), instance: Service())
    container.register(name: UUID(), instance: Service())
    container.register(name: UUID(), instance: Service())
    
    // When
    let services: [Service] = try container.resolve()
    
    // Then
    XCTAssertEqual(services.count, 3)
  }
  
  func test_throwWhenNotFound_sync() throws {
    // Given
    ArrayResolutionConfig.throwResolutionErrorWhenNotFound = true
    
    // When
    do {
      _ = try container.resolve([Service].self)
      XCTFail("Expected to throw .notFound")
    } catch let error as ResolutionError {
      let key = Key([Service].self)
      guard
        error.key == key,
        case .notFound = error.reason
      else {
        throw error
      }
    }
  }
}

extension ArrayTests {
  class Service {}
}
