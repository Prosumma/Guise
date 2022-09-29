//
//  ArgumentTests.swift(.gyb)
//  GuiseTests
//
//  Created by Gregory Higley 2022-09-27.
//

import XCTest
@testable import Guise

class ArgumentTests: XCTestCase {
  var container: (any (Resolver & Registrar))!

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
    container.register { _, arg1 in
      [arg1] as [Int]
    }
    
    // When
    let ints: [Int] = try container.resolve(args: 1)
    
    // Then
    XCTAssertEqual(ints, [1])
  }
  
  func test_sync2() throws {
    // Given
    container.register { _, arg1, arg2 in
      [arg1, arg2] as [Int]
    }
    
    // When
    let ints: [Int] = try container.resolve(args: 1, 2)
    
    // Then
    XCTAssertEqual(ints, [1, 2])
  }
  
  func test_sync3() throws {
    // Given
    container.register { _, arg1, arg2, arg3 in
      [arg1, arg2, arg3] as [Int]
    }
    
    // When
    let ints: [Int] = try container.resolve(args: 1, 2, 3)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3])
  }
  
  func test_sync4() throws {
    // Given
    container.register { _, arg1, arg2, arg3, arg4 in
      [arg1, arg2, arg3, arg4] as [Int]
    }
    
    // When
    let ints: [Int] = try container.resolve(args: 1, 2, 3, 4)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4])
  }
  
  func test_sync5() throws {
    // Given
    container.register { _, arg1, arg2, arg3, arg4, arg5 in
      [arg1, arg2, arg3, arg4, arg5] as [Int]
    }
    
    // When
    let ints: [Int] = try container.resolve(args: 1, 2, 3, 4, 5)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5])
  }
  
  func test_sync6() throws {
    // Given
    container.register { _, arg1, arg2, arg3, arg4, arg5, arg6 in
      [arg1, arg2, arg3, arg4, arg5, arg6] as [Int]
    }
    
    // When
    let ints: [Int] = try container.resolve(args: 1, 2, 3, 4, 5, 6)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5, 6])
  }
  
  func test_sync7() throws {
    // Given
    container.register { _, arg1, arg2, arg3, arg4, arg5, arg6, arg7 in
      [arg1, arg2, arg3, arg4, arg5, arg6, arg7] as [Int]
    }
    
    // When
    let ints: [Int] = try container.resolve(args: 1, 2, 3, 4, 5, 6, 7)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5, 6, 7])
  }
  
  func test_sync8() throws {
    // Given
    container.register { _, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8 in
      [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8] as [Int]
    }
    
    // When
    let ints: [Int] = try container.resolve(args: 1, 2, 3, 4, 5, 6, 7, 8)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5, 6, 7, 8])
  }
  
  func test_sync9() throws {
    // Given
    container.register { _, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 in
      [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9] as [Int]
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
    container.register { _, arg1 async in
      [arg1] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve(args: 1)
    
    // Then
    XCTAssertEqual(ints, [1])
  }

  func test_async2() async throws {
    // Given
    container.register { _, arg1, arg2 async in
      [arg1, arg2] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve(args: 1, 2)
    
    // Then
    XCTAssertEqual(ints, [1, 2])
  }

  func test_async3() async throws {
    // Given
    container.register { _, arg1, arg2, arg3 async in
      [arg1, arg2, arg3] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve(args: 1, 2, 3)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3])
  }

  func test_async4() async throws {
    // Given
    container.register { _, arg1, arg2, arg3, arg4 async in
      [arg1, arg2, arg3, arg4] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve(args: 1, 2, 3, 4)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4])
  }

  func test_async5() async throws {
    // Given
    container.register { _, arg1, arg2, arg3, arg4, arg5 async in
      [arg1, arg2, arg3, arg4, arg5] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve(args: 1, 2, 3, 4, 5)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5])
  }

  func test_async6() async throws {
    // Given
    container.register { _, arg1, arg2, arg3, arg4, arg5, arg6 async in
      [arg1, arg2, arg3, arg4, arg5, arg6] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve(args: 1, 2, 3, 4, 5, 6)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5, 6])
  }

  func test_async7() async throws {
    // Given
    container.register { _, arg1, arg2, arg3, arg4, arg5, arg6, arg7 async in
      [arg1, arg2, arg3, arg4, arg5, arg6, arg7] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve(args: 1, 2, 3, 4, 5, 6, 7)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5, 6, 7])
  }

  func test_async8() async throws {
    // Given
    container.register { _, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8 async in
      [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve(args: 1, 2, 3, 4, 5, 6, 7, 8)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5, 6, 7, 8])
  }

  func test_async9() async throws {
    // Given
    container.register { _, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 async in
      [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9] as [Int]
    }
    
    // When
    let ints: [Int] = try await container.resolve(args: 1, 2, 3, 4, 5, 6, 7, 8, 9)
    
    // Then
    XCTAssertEqual(ints, [1, 2, 3, 4, 5, 6, 7, 8, 9])
  }
}
