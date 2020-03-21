//
//  RegisteredAssembly.swift
//  Guise
//
//  Created by Gregory Higley on 3/3/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

struct RegisteredAssembly: AssemblyRegistration {
  private static let lock = Lock()
  private static var queues: [String: DispatchQueue] = [:]

  /**
   Returns a `DispatchQueue` tied to the type of an `Assembly`. This method
   is idempotent and thread-safe.
   */
  static subscript<A: Assembly>(assembly: A.Type) -> DispatchQueue {
    let key = String(reflecting: assembly)
    if let queue = lock.read({ queues[key] }) {
      return queue
    } else {
      return lock.write {
        // We need to check again. Just because we acquired the
        // lock does not mean that we're the first to create the queue.
        if let queue = queues[key] {
          return queue
        } else {
          let queue = DispatchQueue(label: key, qos: .userInitiated, attributes: [], autoreleaseFrequency: .never, target: nil)
          queues[key] = queue
          return queue
        }
      }
    }
  }
}
