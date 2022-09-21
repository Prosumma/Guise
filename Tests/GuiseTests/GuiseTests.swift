import XCTest
@testable import Guise

final class GuiseTests: XCTestCase {
  func testExample() throws {
    class Foo {}
    class Bar {
      let foo: Foo
      init(foo: Foo) {
        self.foo = foo
      }
    }
      
    let container = Container()
    container.register(service: Foo())
    container.register(lifetime: .singleton, factory: auto(Bar.init))
    
    let bar1 = try container.resolve(Bar.self)
    let bar2 = try container.resolve(Bar.self)
    
    XCTAssert(bar1 === bar2)
  }
  
  func testicles() throws {
    class Foo {
      let i: Int
      init(i: Int) async {
        self.i = i
      }
    }
    
    let container = Container()
    container.register { r, i in
      await Foo(i: i)
    }
    
    do {
      _ = try container.resolve(Foo.self, args: 1)
    } catch let error as ResolutionError {
      guard case .requiresAsync = error.reason else {
        throw error
      }
    }
  }

  func testAsync() async throws {
    class Foo {
      let i: Int
      init(i: Int) async {
        self.i = i
      }
    }
    
    let container = Container()
    container.register { r, i in
      await Foo(i: i)
    }
    
    let foo = try await container.resolve(Foo.self, args: 1)
    XCTAssertEqual(foo.i, 1)
  }
  
  func testAssembly() throws {
    let container = Container()
    container.assemble(TestAssembly())
    _ = try container.resolve(Watusi.self)
  }
}

class TestAssembly: Assembly {
  func register(in registrar: Registrar) {
    registrar.register(service: Watusi())
  }
}

class Watusi {}
