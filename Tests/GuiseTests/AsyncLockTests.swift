//
//  AsyncLockTests.swift
//  GuiseTests
//
//  Created by Greg Higley on 2022-09-22.
//

import XCTest
@testable import Guise

class AsyncLockTests: XCTestCase {
  let lock = AsyncLock()
  var value: [Int] = []
  
  func test_lock() async throws {
    async let task1: Void = lock.lock {
      try await Task.sleep(nanoseconds: 100_000)
      self.value.append(1)
    }
    async let task2: Void = lock.lock {
      self.value.append(2)
    }
    
    _ = try await [task1, task2]
    // This proves that task 2 is waiting on task 1
    XCTAssertEqual(value, [1, 2])
  }
  
}
