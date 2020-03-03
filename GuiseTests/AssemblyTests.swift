//
//  AssemblyTests.swift
//  Guise
//
//  Created by Gregory Higley on 3/3/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import XCTest
import Guise

class AssemblyTests: XCTestCase {

  func testAssemblies() {
    struct InnerDependency {}
    
    struct InnerAssembly: Assembly {
      static var registrationCount = 0
      func register(in container: Registrar & Resolver) {
        container.register(transient: InnerDependency())
      }
      func registered(to resolver: Resolver) {
        Self.registrationCount = Self.registrationCount + 1
      }
    }
    
    struct OuterDependency {
      init(innerDependency: InnerDependency) {
        
      }
    }
    
    struct OuterAssembly: Assembly {
      func register(in container: Registrar & Resolver) {
        container.register(assembly: InnerAssembly())
        container.register(factory: auto(OuterDependency.init))
      }
    }
    
    // We only need to register the outer assembly.
    let container = Container()
    container.register(assembly: OuterAssembly())
    let outerDependency: OuterDependency? = container.resolve()
    XCTAssertNotNil(outerDependency)
    
    // If we register the inner dependency again, it does nothing.
    // Guise tracks assembly registrations by type.
    container.register(assembly: InnerAssembly())
    XCTAssertEqual(1, InnerAssembly.registrationCount)
    
    container.debug()
  }
    
}
