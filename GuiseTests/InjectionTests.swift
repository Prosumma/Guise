//
//  InjectionTests.swift
//  Guise
//
//  Created by Gregory Higley on 2/26/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import XCTest
import Guise

struct Argumentative {
  public static let scope: Scope = .root / "argumentative"

  let arguments: Int
  let counterArguments: Int

  init(_ arguments: Int, _ counterArguments: Int) {
    self.arguments = arguments
    self.counterArguments = counterArguments
  }
}

class InjectionTarget {
  var service: Service!
  var api: Api!
  var argumentative: Argumentative!

  func load() {
    Guise.resolve(into: self, args: [Key(Argumentative.self, in: Argumentative.scope): (7, 3)])
    XCTAssertNotNil(service)
    XCTAssertEqual(argumentative.arguments, 7)
    XCTAssertEqual(argumentative.counterArguments, 3)
  }
}

class InjectionTests: XCTestCase {

  public func testInjection() {
    Guise.register(in: Argumentative.scope, resolve: pass(to: Argumentative.init))
    Guise.register(singleton: ApiImpl() as Api)
    Guise.register { r in r.auto(ServiceImpl.init) as Service }
    Guise.into(target: InjectionTarget.self)
        .inject(\.service)
        .inject(\.api)
        .inject(\.argumentative, in: Argumentative.scope)
        .register()

    let target = InjectionTarget()
    target.load()

    let argumentative: Argumentative = Guise.resolve(in: Argumentative.scope, arg1: 17, arg2: 33)!
    XCTAssertEqual(argumentative.arguments, 17)
    XCTAssertEqual(argumentative.counterArguments, 33)
  }

}
