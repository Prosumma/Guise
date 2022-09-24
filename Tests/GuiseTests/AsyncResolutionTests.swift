//
//  AsyncResolutionTests.swift
//  Guise
//
//  Created by Greg Higley on 2022-09-22.
//

import XCTest
@testable import Guise

final class AsyncResolutionTests: XCTestCase {
  var container: Container!
  
  override func setUp() {
    super.setUp()
    container = Container()
    prepareForGuiseTests()
  }
  
  func test_0_args() async throws {
    // Given
    container.register { _ async in
      [] as [Int]
    }
    
    // When
    let args: [Int] = try await container.resolve()
    
    // Then
    XCTAssertEqual(args, [])
  }
  
  func test_1_args() async throws {
    // Given
    container.register { _, a1 async in
      [a1] as [Int]
    }
    
    // When
    let args: [Int] = try await container.resolve(args: 1)
    
    // Then
    XCTAssertEqual(args, [1])
  }
  
  func test_2_args() async throws {
    // Given
    container.register { _, a1, a2 async in
      [a1, a2] as [Int]
    }
    
    // When
    let args: [Int] = try await container.resolve(args: 1, 2)
    
    // Then
    XCTAssertEqual(args, [1, 2])
  }
  
  func test_3_args() async throws {
    // Given
    container.register { _, a1, a2, a3 async in
      [a1, a2, a3] as [Int]
    }
    
    // When
    let args: [Int] = try await container.resolve(args: 1, 2, 3)
    
    // Then
    XCTAssertEqual(args, [1, 2, 3])
  }
  
  func test_4_args() async throws {
    // Given
    container.register { _, a1, a2, a3, a4 async in
      [a1, a2, a3, a4] as [Int]
    }
    
    // When
    let args: [Int] = try await container.resolve(args: 1, 2, 3, 4)
    
    // Then
    XCTAssertEqual(args, [1, 2, 3, 4])
  }
  
  func test_5_args() async throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5 async in
      [a1, a2, a3, a4, a5] as [Int]
    }
    
    // When
    let args: [Int] = try await container.resolve(args: 1, 2, 3, 4, 5)
    
    // Then
    XCTAssertEqual(args, [1, 2, 3, 4, 5])
  }
  
  func test_6_args() async throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5, a6 async in
      [a1, a2, a3, a4, a5, a6] as [Int]
    }
    
    // When
    let args: [Int] = try await container.resolve(args: 1, 2, 3, 4, 5, 6)
    
    // Then
    XCTAssertEqual(args, [1, 2, 3, 4, 5, 6])
  }
  
  func test_7_args() async throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5, a6, a7 async in
      [a1, a2, a3, a4, a5, a6, a7] as [Int]
    }
    
    // When
    let args: [Int] = try await container.resolve(args: 1, 2, 3, 4, 5, 6, 7)
    
    // Then
    XCTAssertEqual(args, [1, 2, 3, 4, 5, 6, 7])
  }
  
  func test_8_args() async throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5, a6, a7, a8 async in
      [a1, a2, a3, a4, a5, a6, a7, a8] as [Int]
    }
    
    // When
    let args: [Int] = try await container.resolve(args: 1, 2, 3, 4, 5, 6, 7, 8)
    
    // Then
    XCTAssertEqual(args, [1, 2, 3, 4, 5, 6, 7, 8])
  }
  
  func test_9_args() async throws {
    // Given
    container.register { _, a1, a2, a3, a4, a5, a6, a7, a8, a9 async in
      [a1, a2, a3, a4, a5, a6, a7, a8, a9] as [Int]
    }
    
    // When
    let args: [Int] = try await container.resolve(args: 1, 2, 3, 4, 5, 6, 7, 8, 9)
    
    // Then
    XCTAssertEqual(args, [1, 2, 3, 4, 5, 6, 7, 8, 9])
  }
  
  func test_singleton() async throws {
    // Given
    class Singleton {}
    container.register(lifetime: .singleton, instance: Singleton())
    
    async let singleton1 = container.resolve(Singleton.self)
    async let singleton2 = container.resolve(Singleton.self)
    
    Entry.singletonTestDelay = 100_000
    let singletons = try await [singleton1, singleton2]
   
    XCTAssertEqual(Entry.singletonTestDelay, 100_000)
    XCTAssert(singletons[0] === singletons[1])
  }
  
  func test_random_error() async throws {
    // Given
    struct RandomError: Error {}
    Entry.testResolutionError = RandomError()
    container.register { _ async in
      "never"
    }
    
    // When
    do {
      _ = try await container.resolve(String.self)
      XCTFail("Expected to throw an error")
    } catch let error as ResolutionError {
      let key = Key(String.self)
      guard
        error.key == key,
        case .error(_ as RandomError) = error.reason
      else {
        throw error
      }
    }
  }
}
