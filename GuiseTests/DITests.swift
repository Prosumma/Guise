//
//  DITests.swift
//  Guise
//
//  Created by Gregory Higley on 3/2/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import XCTest
import Guise

class DITests: XCTestCase {
    
  func testSingletons() {
    class Dependency {
      
    }
    
    class Service {
      let dependency: Dependency
      init(dependency: Dependency) { self.dependency = dependency }
    }
    
    let container: Container = Guise()
    // The auto higher-order function automatically
    // registers the dependencies found in Service.init. This
    // only works if ALL of the init parameters are registered
    // dependencies.
    container.singleton.register(factory: auto(Service.init))
    container.register(singleton: Dependency())
    
    let service1: Service = container.resolve()!
    let service2: Service = container.resolve()!
    XCTAssert(service1 === service2)
    XCTAssert(service1.dependency === service2.dependency)
  }
  
  func testConstruct() {
    struct Worthless {
      let i: Int
      init(i: Int) { self.i = i }
      init(i: Int, s: String) { self.init(i: i) }
    }
    
    let container: Container = Guise()
    container.register(factory: construct(Worthless.init(i:)))
    
    let worthless: Worthless = container.resolve(arg: 7)!
    XCTAssertEqual(7, worthless.i)
  }
  
  func testZeroArgConstruct() {
    struct Zero {
      init() {}
    }
    
    let container: Container = Guise()
    
    // There is no overload of `construct` that takes an
    // initializer with no arguments. Yet it works! The
    // reason is that `Void` is a type in Swift, and
    // a zero-argument function or initializer has
    // an implicit argument of type `Void`.
    container.register(factory: construct(Zero.init))
    let zero: Zero? = container.resolve()
    XCTAssertNotNil(zero)
  }
  
  func testScopeHierarchy() {
    class Something {}
    
    let derivedScope: Scope = .default / UUID()
    let container: Container = Guise()
    // Register in the default scope
    container.register(singleton: Something())
    // Attempt to resolve in the derived scope,
    // whose parent is the default scope. This
    // should succeed. When the registration is not
    // found in derivedScope, its parent is searched,
    // and the registration is found and resolved.
    let something: Something? = container.resolve(in: derivedScope)
    XCTAssertNotNil(something)
  }

}
