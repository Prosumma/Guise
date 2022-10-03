//
//  RunBlocking.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

import Foundation

/**
 Executes an async closure in a synchronous environment.
 
 This function is potentially dangerous and may cause a deadlock if it
 runs on a thread in the async threadpool, which is managed by the runtime.
 
 Apple says that there is one async thread per processor core, no more and
 no less. They strongly recommend never blocking such a thread.
 
 This function does not block the `async` closure that is passed to it. The
 semaphore is signaled at the end, but it does block the calling thread,
 and if that thread is an `async` thread, then a deadlock is possible.
 
 This function is used by `Entry` to resolve `async` entries only if
 `Entry.allowSynchronousResolutionOfAsyncEntries` is `true`. It is `false`
 by default.
 */
func runBlocking<T>(_ closure: @escaping () async throws -> T) throws -> T {
  let box = Box<Result<T, Error>>()
  let semaphore = DispatchSemaphore(value: 0)
  Task {
    defer { semaphore.signal() }
    do {
      box.value = try await .success(closure())
    } catch {
      box.value = .failure(error)
    }
  }
  semaphore.wait()
  return try box.value.get()
}

class Box<T> {
  var value: T!
}
