//
//  DITests.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import XCTest
import Guise

class DITests: XCTestCase {

  func testInts() {
    Guise.register(factory: 7)
    let i: Int = Guise.resolve(scope: .root • 7)!
    XCTAssertEqual(i, 7)
  }

}
