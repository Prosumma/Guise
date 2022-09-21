//
//  AsyncLock.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

import Atomics

class AsyncLock {
  static let sleepNanoseconds: UInt64 = 1_000
  
  let locked = ManagedAtomic(false)
  
  @discardableResult
  func lock<T>(_ closure: () async throws -> T) async throws -> T {
    defer { locked.store(false, ordering: .sequentiallyConsistent) }
    while locked.exchange(true, ordering: .sequentiallyConsistent) {
      try await Task.sleep(nanoseconds: Self.sleepNanoseconds)
    }
    return try await closure()
  }
}
