//
//  DITests.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import XCTest
import Guise

protocol Api {
  
}

class ApiImpl: Api {}

protocol Service: class {
  var api: Api { get }
}

class ServiceImpl: Service {
  public let api: Api
  init(api: Api) {
    self.api = api
  }
}

enum Name {
  case integers
}

class DITests: XCTestCase {

  func testInts() {
    Guise.register(singleton: 3, in: .root)
    Guise.register(singleton: 7, in: .root / Name.integers)
    let i: Int = Guise.resolve(in: .root / Name.integers)!
    XCTAssertEqual(i, 7)
  }
  
  func testAutoAndSingletonBehavior() {
    Guise.register(singleton: ApiImpl() as Api)
    Guise.register(lifetime: .singleton) { r in
      r.auto(ServiceImpl.init) as Service
    }
    let service1: Service? = Guise.resolve()
    XCTAssertNotNil(service1?.api)
    let service2: Service? = Guise.resolve()
    XCTAssertTrue(service1 === service2)
  }

}
