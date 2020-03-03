//
//  InjectionTests.swift
//  Guise
//
//  Created by Gregory Higley on 3/3/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import XCTest
import Guise

let sharedContainer: Resolver & Registrar = Container()

class InjectionTests: XCTestCase {

  func testKeyPathInjection() {
    class InnerDependency {
      
    }
    
    class OuterViewController {
      var inner: InnerDependency?
      
      init() {
        sharedContainer.resolve(into: self)
      }
    }
    
    sharedContainer.register(factory: construct(InnerDependency.init))
    sharedContainer.into(target: OuterViewController.self).inject(\.inner).register()
    let outer = OuterViewController()
    XCTAssertNotNil(outer.inner)
  }
  
}
