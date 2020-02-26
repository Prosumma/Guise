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

protocol Service {
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
    Guise.register(factory: 7, scope: .root • Name.integers)
    let i: Int = Guise.resolve(scope: .root • Name.integers)!
    XCTAssertEqual(i, 7)
  }
  
  func testAuto() {
    Guise.register(singleton: ApiImpl() as Api)
    Guise.register(lifetime: .singleton) { r in
      r.auto(ServiceImpl.init) as Service
    }
    let service: Service? = Guise.resolve()
    XCTAssertNotNil(service?.api)
  }

}
