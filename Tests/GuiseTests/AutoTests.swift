//
//  AutoTests.swift
//  GuiseTests
//
//  Created by Gregory Higley 2022-09-24.
//

import XCTest
@testable import Guise

class AutoTests: XCTestCase {
  var container: Container!
  
  override func setUp() {
    super.setUp()
    container = Container()
    container.register(factory: auto(Dependency.init))
  }
  
  func test0() throws {
    _ = try container.resolve(Dependency.self)
  }
  
  func test1() throws {
    container.register(factory: auto(Dependency1.init))
    _ = try container.resolve(Dependency1.self)
  }
  
  func test2() throws {
    container.register(factory: auto(Dependency2.init))
    _ = try container.resolve(Dependency2.self)
  }
  
  func test3() throws {
    container.register(factory: auto(Dependency3.init))
    _ = try container.resolve(Dependency3.self)
  }
  
  func test4() throws {
    container.register(factory: auto(Dependency4.init))
    _ = try container.resolve(Dependency4.self)
  }

  func test5() throws {
    container.register(factory: auto(Dependency5.init))
    _ = try container.resolve(Dependency5.self)
  }

  func test6() throws {
    container.register(factory: auto(Dependency6.init))
    _ = try container.resolve(Dependency6.self)
  }

  func test7() throws {
    container.register(factory: auto(Dependency7.init))
    _ = try container.resolve(Dependency7.self)
  }

  func test8() throws {
    container.register(factory: auto(Dependency8.init))
    _ = try container.resolve(Dependency8.self)
  }

  func test9() throws {
    container.register(factory: auto(Dependency9.init))
    _ = try container.resolve(Dependency9.self)
  }
}

extension AutoTests {
  class Dependency {}
  class Dependency1 {
    init(d1: Dependency) {}
  }
  class Dependency2 {
    init(d1: Dependency, d2: Dependency) {}
  }
  class Dependency3 {
    init(d1: Dependency, d2: Dependency, d3: Dependency) {}
  }
  class Dependency4 {
    init(
      d1: Dependency,
      d2: Dependency,
      d3: Dependency,
      d4: Dependency
    ) {}
  }
  class Dependency5 {
    init(
      d1: Dependency,
      d2: Dependency,
      d3: Dependency,
      d4: Dependency,
      d5: Dependency
    ) {}
  }
  class Dependency6 {
    init(
      d1: Dependency,
      d2: Dependency,
      d3: Dependency,
      d4: Dependency,
      d5: Dependency,
      d6: Dependency
    ) {}
  }
  class Dependency7 {
    init(
      d1: Dependency,
      d2: Dependency,
      d3: Dependency,
      d4: Dependency,
      d5: Dependency,
      d6: Dependency,
      d7: Dependency
    ) {}
  }
  class Dependency8 {
    init(
      d1: Dependency,
      d2: Dependency,
      d3: Dependency,
      d4: Dependency,
      d5: Dependency,
      d6: Dependency,
      d7: Dependency,
      d8: Dependency
    ) {}
  }
  class Dependency9 {
    init(
      d1: Dependency,
      d2: Dependency,
      d3: Dependency,
      d4: Dependency,
      d5: Dependency,
      d6: Dependency,
      d7: Dependency,
      d8: Dependency,
      d9: Dependency
    ) {}
  }
}
