//
//  ArgumentTests.swift(.gyb)
//  GuiseTests
//
//  Created by Gregory Higley 2022-09-27.
//

import XCTest
@testable import Guise

class ArgumentTests: XCTestCase {
  var container: Container!

  override func setUp() {
    super.setUp()
    container = Container()
    prepareForGuiseTests()
  }

  // MARK: Synchronous
  
  func test_sync0() throws {
    // Given
    container.register { _ in
      [] as [Int]
    }
    
    // When
    let ints: [Int] = try container.resolve()
    
    // Then
    XCTAssertEqual(ints, [])
  }
  
  func test_sync1() throws {
    // Given
    container.register { _, a1 in
      [a1] as [Int]
    }
    
    // When
    let ints: [Int] = try container.resolve(args: 1)
    
    // Then
    XCTAssertEqual(ints, [1])
  }
  
  func test_sync2() throws {
    // Given
    container.register { _, a1, a2 in
      [a1, a2] as [Int]
    }
    
    // When
    let ints: [Int] = try container.resolve(args: 1, 2)
    
    // Then
    XCTAssertEqual(ints, [1, 2])
  }
  
  func test_sync3() throws {
    // Given
    container.register { _, a1, a2, a3 in
      [a1, a2, a3] as [Int]
    }
    
    // When
    let ints: [Int] = try container.resolve(args: 1, 2, 3)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3])
  }
  
  func test_sync4() throws {
    // Given
    container.register { _, a1, a2, a3, a4 in
      [a1, a2, a3, a4] as [Int]
    }
    
    // When
    let ints: [Int] = try container.resolve(args: 1, 2, 3, 4)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4])
  }
  
  func test_sync5() throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5 in
      [a1, a2, a3, a4, a5] as [Int]
    }
    
    // When
    let ints: [Int] = try container.resolve(args: 1, 2, 3, 4, 5)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5])
  }
  
  func test_sync6() throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5, a6 in
      [a1, a2, a3, a4, a5, a6] as [Int]
    }
    
    // When
    let ints: [Int] = try container.resolve(args: 1, 2, 3, 4, 5, 6)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5, 6])
  }
  
  func test_sync7() throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5, a6, a7 in
      [a1, a2, a3, a4, a5, a6, a7] as [Int]
    }
    
    // When
    let ints: [Int] = try container.resolve(args: 1, 2, 3, 4, 5, 6, 7)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5, 6, 7])
  }
  
  func test_sync8() throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5, a6, a7, a8 in
      [a1, a2, a3, a4, a5, a6, a7, a8] as [Int]
    }
    
    // When
    let ints: [Int] = try container.resolve(args: 1, 2, 3, 4, 5, 6, 7, 8)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5, 6, 7, 8])
  }
  
  func test_sync9() throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5, a6, a7, a8, a9 in
      [a1, a2, a3, a4, a5, a6, a7, a8, a9] as [Int]
    }
    
    // When
    let ints: [Int] = try container.resolve(args: 1, 2, 3, 4, 5, 6, 7, 8, 9)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5, 6, 7, 8, 9])
  }
  
  // MARK: Asynchronous

  func test_async0() async throws {
    // Given
    container.register { _ async in
      [] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve()
    
    // Then
    XCTAssertEqual(ints, [])
  }
  
  func test_async1() async throws {
    // Given
    container.register { _, a1 async in
      [a1] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve(args: 1)
    
    // Then
    XCTAssertEqual(ints, [1])
  }
  
  func test_async2() async throws {
    // Given
    container.register { _, a1, a2 async in
      [a1, a2] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve(args: 1, 2)
    
    // Then
    XCTAssertEqual(ints, [1, 2])
  }
  
  func test_async3() async throws {
    // Given
    container.register { _, a1, a2, a3 async in
      [a1, a2, a3] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve(args: 1, 2, 3)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3])
  }
  
  func test_async4() async throws {
    // Given
    container.register { _, a1, a2, a3, a4 async in
      [a1, a2, a3, a4] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve(args: 1, 2, 3, 4)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4])
  }
  
  func test_async5() async throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5 async in
      [a1, a2, a3, a4, a5] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve(args: 1, 2, 3, 4, 5)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5])
  }
  
  func test_async6() async throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5, a6 async in
      [a1, a2, a3, a4, a5, a6] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve(args: 1, 2, 3, 4, 5, 6)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5, 6])
  }
  
  func test_async7() async throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5, a6, a7 async in
      [a1, a2, a3, a4, a5, a6, a7] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve(args: 1, 2, 3, 4, 5, 6, 7)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5, 6, 7])
  }
  
  func test_async8() async throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5, a6, a7, a8 async in
      [a1, a2, a3, a4, a5, a6, a7, a8] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve(args: 1, 2, 3, 4, 5, 6, 7, 8)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5, 6, 7, 8])
  }
  
  func test_async9() async throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5, a6, a7, a8, a9 async in
      [a1, a2, a3, a4, a5, a6, a7, a8, a9] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve(args: 1, 2, 3, 4, 5, 6, 7, 8, 9)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5, 6, 7, 8, 9])
  }
  
}
