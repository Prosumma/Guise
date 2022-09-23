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
    prepareForGuiseTests()
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
  
  func test_singleton() throws {
    // Given
    class Singleton {}
    container.register(lifetime: .singleton, instance: Singleton())
    let semaphore = DispatchSemaphore(value: 0)
    var singleton1: Singleton?
    var singleton2: Singleton?
    
    // When
    Entry.singletonTestDelay = 100_000
    Thread {
      singleton1 = try? self.container.resolve()
      semaphore.signal()
    }.start()
    Thread {
      singleton2 = try? self.container.resolve()
      semaphore.signal()
    }.start()
    
    semaphore.wait()
    semaphore.wait()
    
    // Then
    XCTAssertEqual(Entry.singletonTestDelay, 100_000)
    XCTAssertNotNil(singleton1)
    print("\(Unmanaged.passUnretained(singleton1!).toOpaque()) \(Unmanaged.passUnretained(singleton2!).toOpaque())")
    XCTAssert(singleton1 === singleton2)
  }
  
  func test_resolve_async_fail() throws {
    // Given
    container.register { _ async in
      "async"
    }
    
    // When
    do {
      _ = try container.resolve(String.self)
      XCTFail("Expected to throw .requiresAsync")
    } catch let error as ResolutionError {
      let key = Key(String.self)
      guard
        case .requiresAsync = error.reason,
        error.key == key
      else {
        throw error
      }
    }
  }
  
  func test_resolve_async() throws {
    // Given
    Entry.allowSynchronousResolutionOfAsyncEntries = true
    container.register { _ async in
      "async"
    }
    
    // When
    let s: String = try container.resolve()
    
    // Then
    XCTAssertEqual(s, "async")
  }
  
  func test_random_error() throws {
    // Given
    struct RandomError: Error {}
    Entry.testResolutionError = RandomError()
    container.register { _ in
      "never"
    }
    
    // When
    do {
      _ = try container.resolve(String.self)
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

