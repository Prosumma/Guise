//
//  ResolutionTests.swift
//  GuiseTests
//
//  Created by Greg Higley on 2022-09-21.
//

import XCTest
@testable import Guise

final class ResolutionTests: XCTestCase {
  func test1() throws {
    let container = Container()
    container.assemble(TestAssembly())
    
    let silly: Silly = try container.resolve()
    
    XCTAssertEqual(silly.watusis.count, 2)
  }
  
  func test2() throws {
    let container = Container()
    container.register { _ in
      await Async()
    }
    container.register(factory: auto(Sync.init))
    
    do {
      _ = try container.resolve(Sync.self)
      XCTFail("Expected to throw an error.")
    } catch _ as ResolutionError {
      
    }
  }
}

class Watusi {}
class Silly {
  let watusis: [Watusi]
  init(watusis: LazyNameResolver<[Watusi]>) throws {
    self.watusis = try watusis.resolve()
  }
}

enum Registration {
  case watusi
}

class Async {
  init() async {}
}

class Sync {
  let `async`: Async
  init(async: LazyResolver<Async>) throws {
    self.async = try `async`.resolve()
  }
}

class TestAssembly: Assembly {
  func register(in registrar: Registrar) {
    registrar.register(name: UUID(), Registration.watusi, instance: Watusi())
    registrar.register(name: UUID(), Registration.watusi, instance: Watusi())
    registrar.register(name: UUID(), instance: Watusi())
    registrar.register(lifetime: .singleton) { r in
      try Silly(watusis: r.resolve(name: Registration.watusi))
    }
  }
}
