//
//  File.swift
//  
//
//  Created by Gregory Higley on 3/28/20.
//

import XCTest
import Guise

class FilterTests: XCTestCase {

  func testFilters() {
    final class Singleton {
      
    }
    let container: Registrar & Resolver = Container()
    for i in 0..<5 {
      container.in(.default / i).register(singleton: Singleton())
    }
    container.in(.factories / UUID()).register(singleton: Singleton())
    var registrations: [Key: Registration] = container.filter(scope(in: .default) && key(type: Singleton.self))
    XCTAssertEqual(5, registrations.count)
    registrations = container.filter(key(type: Singleton.self))
    XCTAssertEqual(6, registrations.count)
  }
  
}
