//
//  KeyTests.swift
//  GuiseTests
//
//  Created by Gregory Higley on 2022-09-24.
//

import XCTest
import Guise

final class KeyTests: XCTestCase {
  func test_key_description() {
    let key = Key(String.self, tags: [2, "a"], args: Int.self)
    XCTAssertEqual(
      String(describing: key),
      "Key(Swift.String, tags: \"a\", 2, args: Swift.Int)"
    )
  }
}
