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
    let scope1 = Scope.registrations / "scope" / "broke"
    let scope2 = Scope.registrations / "scope" / "broke"
    XCTAssertEqual(scope1, scope2)
  }
  
  func testScopeUnequivalence() {
    let scope1 = Scope.registrations / "scope" / "scope1"
    let scope2 = Scope.registrations / "scope" / "scope2"
    XCTAssertNotEqual(scope1, scope2)
  }
  
  func testScopeHasPrefix() {
    let prefix = Scope.registrations / "prefix"
    let scope = prefix / UUID()
    XCTAssertTrue(scope.starts(with: prefix))
  }
  
  func testScopeLacksPrefix() {
    let prefix = Scope.registrations / "prefix" / UUID()
    let scope = Scope.registrations / UUID()
    XCTAssertFalse(prefix.starts(with: scope))
  }
  
  func testSomething() {
    let watusi: Scope = Scope("watusi") / "foo"
    let arugula: Scope = .registrations / "arugula" / UUID()
    let watusiArugula = watusi / arugula
    let watusiArugulaString = watusiArugula / String.self
    print(watusiArugulaString)
  }
    
}



