//
//  AssemblyTests.swift
//  GuiseTests
//
//  Created by Gregory Higley 2022-09-24.
//

import XCTest
@testable import Guise

class AssemblyTests: XCTestCase {
  func test_assembly() throws {
    let container = Container()
    try container.assemble(TestAssembly())
    let service = try container.resolve(Service.self)
    XCTAssertEqual(service.x, 1)
  }
}

extension AssemblyTests {
  class Service {
    var x = 0
  }

  class TestAssembly: Assembly {
    func register(in registrar: Registrar) {
      registrar.register(lifetime: .singleton, instance: Service())
    }

    func registered(to resolver: Resolver) throws {
      let service = try resolver.resolve(Service.self)
      service.x = 1
    }
  }
}
