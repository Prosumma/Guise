//
//  UnregisterTests.swift
//  GuiseTests
//
//  Created by Gregory Higley on 2022-10-03.
//

import XCTest
@testable import Guise

final class UnregisterTests: XCTestCase {
  override func setUp() {
    super.setUp()
    prepareForGuiseTests()
  }

  func test_unregister() {
    // Given
    let key = Key(String.self)
    let criteria = Criteria(key: key)
    let container = Container()

    // When
    container.register(instance: "unregister")

    // Then
    XCTAssertEqual(container.resolve(criteria: criteria).count, 1)

    // When
    container.unregister(keys: key)

    // Then
    XCTAssertEqual(container.resolve(criteria: criteria).count, 0)
  }

  func test_unregister_criteria() {
    // Given
    let container = Container()
    container.register(tags: "string", 1, instance: "1")
    container.register(tags: "string", 2, instance: "2")
    container.register(tags: "string", instance: 3)
    let criteria = Criteria(String.self, tags: .contains("string"))

    // When/Then
    XCTAssertEqual(container.resolve(criteria: criteria).count, 2)

    // When
    container.unregister(criteria: criteria)

    // Then
    XCTAssertEqual(container.resolve(criteria: criteria).count, 0)
  }
}
