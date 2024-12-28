//
//  KeyTests.swift
//  Guise
//
//  Created by Gregory Higley on 2024-12-18.
//

import Guise
import Testing

@Test func testEquatable() throws {
  let key1 = Key<Int>(tags: 1)
  let key2 = AnyKey(Int.self, tags: 1)
  let key3 = Key<String>()
  #expect(key1 == key2)
  #expect(key2 == key1)
  #expect(key2 != key3)
  #expect(key3 != key2)
}

@Test func testFailableInitSucceeds() {
  let key = AnyKey(Int.self, tags: 1)
  #expect(Key<Int>(key) != nil)
}

@Test func testFailableInitFails() {
  let key = AnyKey(Int.self, tags: 1)
  #expect(Key<Singleton>(key) == nil)
}
