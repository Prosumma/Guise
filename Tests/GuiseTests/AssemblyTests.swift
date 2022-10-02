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
    let container: any (Resolver & Assembler) = Container()
    container.assemble(TestAssembly())
    let service = try container.resolve(Service.self)
    XCTAssertEqual(service.x, 1)
  }
  
  func test_assemblies() throws {
    let container: any (Resolver & Assembler) = Container()
    container.assemble(RootAssembly(UtilAssembly(), TestAssembly()))
    let service = try container.resolve(Service.self)
    XCTAssertEqual(service.x, 1)
  }
}

extension AssemblyTests {
  class Service {
    var x = 0
  }
  
  class UtilAssembly: Assembly {
    func register(in registrar: Registrar) {
      registrar.register(instance: 1)
    }
  }

  class TestAssembly: Assembly {
    let dependentAssemblies: [Assembly] = [UtilAssembly()]
    
    func register(in registrar: Registrar) {
      registrar.register(lifetime: .singleton, instance: Service())
    }

    func registered(to resolver: Resolver) {
      let i = try! resolver.resolve(Int.self)
      let service = try! resolver.resolve(Service.self)
      service.x = i
    }
  }
}
