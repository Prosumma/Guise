//
//  ScopeTests.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import XCTest
import Guise

class ScopeTests: XCTestCase {

  func testScopeEquivalence() {
    let scope1 = Scope.root / "scope" / "broke"
    let scope2 = Scope.root / "scope" / "broke"
    XCTAssertEqual(scope1, scope2)
  }
  
  func testScopeUnequivalence() {
    let scope1 = Scope.root / "scope" / "scope1"
    let scope2 = Scope.root / "scope" / "scope2"
    XCTAssertNotEqual(scope1, scope2)
  }
  
  func testScopeHasPrefix() {
    let prefix = Scope.root / "prefix"
    let scope = prefix / UUID()
    XCTAssertTrue(scope.starts(with: prefix))
  }
  
  func testScopeLacksPrefix() {
    let prefix = Scope.root / "prefix" / UUID()
    let scope = Scope.root / UUID()
    XCTAssertFalse(prefix.starts(with: scope))
  }
  
  func testScopeDescription() {
    let scope = Scope.root / "hello"
    XCTAssertEqual("\(scope)", "root/hello")
  }
  
}



