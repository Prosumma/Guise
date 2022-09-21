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
}
