//
//  CriteriaTests.swift
//  Guise
//
//  Created by Gregory Higley on 2024-12-18.
//

import Testing

@testable import Guise

@Test func testCriteria_initWithEachTag() throws {
  let criteria = Criteria<Int>(tags: "foo", 3)
  let key = Key<Int>(tags: "foo", 3)
  #expect(criteria.matches(key))
}

@Test func testCriteria_initWithEachTag_matchesSubset() throws {
  let criteria = Criteria<Int>(op: .subset, tags: "foo")
  let key = Key<Int>(tags: "foo", 3)
  #expect(criteria.matches(key))
}

@Test func testCriteria_initFromKey() throws {
  let key = Key<Int>(tags: 7)
  let criteria = Criteria(from: key)
  #expect(criteria.matches(AnyKey(key)))
}

@Test func testCriteria_matchesSubset() throws {
  let criteria = Criteria<Int>(op: .subset, tags: 7)
  let key = Key<Int>(tags: 7, 3)
  #expect(criteria.matches(AnyKey(key)))
}

@Test func testCriteria_keyDoesNotMatch() throws {
  let key = Key<Int>(tags: 7)
  let criteria = Criteria<String>(tags: 7)
  #expect(!criteria.matches(AnyKey(key)))
}
