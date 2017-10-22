//
//  GuiseFactoryResolutionTests.swift
//  Guise
//
//  Created by Gregory Higley on 10/22/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import XCTest
@testable import Guise

class GuiseFactoryResolutionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        _ = Guise.clear()
    }
    
    func testSimpleFactoryResolution() {
        // The factory parameter is an autoclosure, so the parameter is evaluated lazily (and repeatedly).
        _ = Guise.register(factory: Xig() as Upwit)
        guard // Four different ways to give type evidence to `resolve()`
            let upwit1 = Guise.resolve(type: Upwit.self),
            let upwit2: Upwit = Guise.resolve(),
            let upwit3 = Guise.resolve() as Upwit?,
            let upwit4 = Guise.resolve(key: Key<Upwit>())
        else {
            XCTFail("Factory resolution failed.")
            return
        }
        XCTAssertFalse(upwit1 === upwit2 && upwit2 === upwit3 && upwit3 === upwit4, "Factory resolution failed.")
    }

}
