//
//  ContainerTests.swift
//  GuiseTests
//
//  Created by Gregory Higley on 2022-10-03.
//

import XCTest
@testable import Guise

final class ContainerTests: XCTestCase {
  override func setUp() {
    super.setUp()
    prepareForGuiseTests()
  }
  
  func test_parent() throws {
    // Given
    let parent = Container()
    let child = Container(parent: parent)
    
    // When
    parent.register(instance: "instance")
    let instance: String = try child.resolve()
    
    // Then
    XCTAssertEqual(instance, "instance")
  }
  
  func test_override() throws {
    // Given
    let parent = Container()
    let child = Container(parent: parent)
    
    // When
    parent.register(instance: "parent")
    child.register(instance: "child")
    let instance: String = try child.resolve()
    
    // Then
    XCTAssertEqual(instance, "child")
  }
}
