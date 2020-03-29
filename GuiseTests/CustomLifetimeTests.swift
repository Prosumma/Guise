//
//  File.swift
//  
//
//  Created by Gregory Higley on 3/29/20.
//

import Foundation
import XCTest
import Guise

class CountedFactory: LifetimeRegistration {
  private var count: Int
  private var _factory: Resolve<Any, Any>
  private let lock = Lock()
  
  required init<Type, Arg>(type: Type.Type, factory: @escaping (Resolver, Arg) -> Type, metadata: Any, state: Any) {
    count = (state as? Int) ?? 1
    _factory = { r, arg in factory(r, arg as! Arg) }
    assert(count >= 0)
  }
  
  func resolve<Type, Arg>(type: Type.Type = Type.self, resolver: Resolver, arg: Arg) -> Type? {
    if count == 0 {
      return nil
    }
    return lock.write {
      if count == 0 {
        return nil
      }
      defer { count -= 1 }
      return (_factory(resolver, arg) as! Type)
    }
  }
}

extension Lifetime {
  static func counted(_ count: Int) -> Lifetime {
    Lifetime(CountedFactory.self, state: count)
  }
}

extension FactoryBuilderProtocol {
  func counted(_ count: Int) -> FactoryBuilder {
    lifetime(.counted(count))
  }
}

class CustomLifetimeTests: XCTestCase {
  func testCustomLifetime() {
    class Dependency {}
    
    let container: Container = Guise()
    container.counted(3).register(factory: construct(Dependency.init))
    var dep: Dependency? = container.resolve()
    XCTAssertNotNil(dep)
    dep = container.resolve()
    XCTAssertNotNil(dep)
    dep = container.resolve()
    XCTAssertNotNil(dep)
    dep = container.resolve()
    XCTAssertNil(dep)
  }
}
