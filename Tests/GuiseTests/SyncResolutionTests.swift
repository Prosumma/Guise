//
//  SyncResolutionTests.swift
//  GuiseTests
//
//  Created by Greg Higley on 2022-09-21.
//

import XCTest
@testable import Guise

final class SyncResolutionTests: XCTestCase {
  var container: Container!
  
  override func setUp() {
    super.setUp()
    container = Container()
  }
  
  func test_0_args() throws {
    // Given
    container.register { _ in
      [] as [Int]
    }
    
    // When
    let args: [Int] = try container.resolve()
    
    // Then
    XCTAssertEqual(args, [])
  }
  
  func test_1_args() throws {
    // Given
    container.register { _, a1 in
      [a1] as [Int]
    }
    
    // When
    let args: [Int] = try container.resolve(args: 1)
    
    // Then
    XCTAssertEqual(args, [1])
  }
  
  func test_2_args() throws {
    // Given
    container.register { _, a1, a2 in
      [a1, a2] as [Int]
    }
    
    // When
    let args: [Int] = try container.resolve(args: 1, 2)
    
    // Then
    XCTAssertEqual(args, [1, 2])
  }
  
  func test_3_args() throws {
    // Given
    container.register { _, a1, a2, a3 in
      [a1, a2, a3] as [Int]
    }
    
    // When
    let args: [Int] = try container.resolve(args: 1, 2, 3)
    
    // Then
    XCTAssertEqual(args, [1, 2, 3])
  }
  
  func test_4_args() throws {
    // Given
    container.register { _, a1, a2, a3, a4 in
      [a1, a2, a3, a4] as [Int]
    }
    
    // When
    let args: [Int] = try container.resolve(args: 1, 2, 3, 4)
    
    // Then
    XCTAssertEqual(args, [1, 2, 3, 4])
  }
  
  func test_5_args() throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5 in
      [a1, a2, a3, a4, a5] as [Int]
    }
    
    // When
    let args: [Int] = try container.resolve(args: 1, 2, 3, 4, 5)
    
    // Then
    XCTAssertEqual(args, [1, 2, 3, 4, 5])
  }
  
  func test_6_args() throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5, a6 in
      [a1, a2, a3, a4, a5, a6] as [Int]
    }
    
    // When
    let args: [Int] = try container.resolve(args: 1, 2, 3, 4, 5, 6)
    
    // Then
    XCTAssertEqual(args, [1, 2, 3, 4, 5, 6])
  }
  
  func test_7_args() throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5, a6, a7 in
      [a1, a2, a3, a4, a5, a6, a7] as [Int]
    }
    
    // When
    let args: [Int] = try container.resolve(args: 1, 2, 3, 4, 5, 6, 7)
    
    // Then
    XCTAssertEqual(args, [1, 2, 3, 4, 5, 6, 7])
  }
  
  func test_8_args() throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5, a6, a7, a8 in
      [a1, a2, a3, a4, a5, a6, a7, a8] as [Int]
    }
    
    // When
    let args: [Int] = try container.resolve(args: 1, 2, 3, 4, 5, 6, 7, 8)
    
    // Then
    XCTAssertEqual(args, [1, 2, 3, 4, 5, 6, 7, 8])
  }
  
  func test_9_args() throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5, a6, a7, a8, a9 in
      [a1, a2, a3, a4, a5, a6, a7, a8, a9] as [Int]
    }
    
    // When
    let args: [Int] = try container.resolve(args: 1, 2, 3, 4, 5, 6, 7, 8, 9)
    
    // Then
    XCTAssertEqual(args, [1, 2, 3, 4, 5, 6, 7, 8, 9])
  }
  
  func test_instance() throws {
    // Given
    container.register(instance: [9, 8, 7])
    
    // When
    let args: [Int] = try container.resolve()
    
    // Then
    XCTAssertEqual(args, [9, 8, 7])
  }
}

