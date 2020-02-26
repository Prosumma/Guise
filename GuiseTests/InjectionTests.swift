//
//  InjectionTests.swift
//  Guise
//
//  Created by Gregory Higley on 2/26/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import XCTest
import Guise

class InjectionTarget {
  var api: Api!

  func load() {
    Guise.resolve(into: self)
  }
}

class InjectionTests: XCTestCase {

  public func testInjection() {
    let apiScope: Scope = .default / "api"

    Guise.register(singleton: ApiImpl() as Api, in: apiScope)
    Guise.into(target: InjectionTarget.self).inject(\.api, in: apiScope).register()
  }

}
