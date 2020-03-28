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
    let scope1 = Scope.factories / "scope" / "broke"
    let scope2 = Scope.factories / "scope" / "broke"
    XCTAssertEqual(scope1, scope2)
  }
  
  func testScopeUnequivalence() {
    let scope1 = Scope.factories / "scope" / "scope1"
    let scope2 = Scope.factories / "scope" / "scope2"
    XCTAssertNotEqual(scope1, scope2)
  }
  
  func testScopeHasPrefix() {
    let prefix = Scope.factories / "prefix"
    let scope = prefix / UUID()
    XCTAssertTrue(scope.starts(with: prefix))
  }
  
  func testScopeLacksPrefix() {
    let prefix = Scope.factories / "prefix" / UUID()
    let scope = Scope.factories / UUID()
    XCTAssertFalse(prefix.starts(with: scope))
  }
  
  func testSomething() {
    let watusi: Scope = Scope("watusi") / "foo"
    let arugula: Scope = .factories / "arugula" / UUID()
    let watusiArugula = watusi / arugula
    let watusiArugulaString = watusiArugula / String.self
    print(watusiArugulaString)
  }
    
}



