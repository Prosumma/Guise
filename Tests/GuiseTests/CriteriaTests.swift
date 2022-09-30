//
//  CriteriaTests.swift
//  GuiseTests
//
//  Created by Gregory Higley on 2022-09-25.
//

import XCTest
@testable import Guise

/**
 `Criteria` is implicitly tested by many other
 tests. These are just here to provide coverage.
 */
final class CriteriaTests: XCTestCase {
  func test_criteria_type_name() {
    // Given
    let name: Criteria.Name = .equals("x", 2, UUID())
    let criteria = Criteria(String.self, name: name)

    // Then
    XCTAssertNotNil(criteria.type)
    XCTAssertEqual(criteria.name?.name.count, 3)
    XCTAssertEqual(criteria.name?.comparison, .equals)
    XCTAssertNil(criteria.args)
    XCTAssertNil(criteria.lifetime)
  }

  func test_criteria_args() {
    // Given
    let criteria = Criteria(args: Int.self)

    // Then
    XCTAssertEqual(criteria.args, "Swift.Int")
    XCTAssertNil(criteria.type)
    XCTAssertNil(criteria.name)
    XCTAssertNil(criteria.lifetime)
  }

  func test_criteria_lifetime() {
    // Given
    let criteria = Criteria(lifetime: .singleton)

    // Then
    XCTAssertNotNil(criteria.lifetime)
    XCTAssertNil(criteria.type)
    XCTAssertNil(criteria.name)
    XCTAssertNil(criteria.args)
  }
}
