//
//  GuiseInstanceResolutionTests.swift
//  Guise
//
//  Created by Gregory Higley on 10/21/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import XCTest
@testable import Guise

class GuiseInstanceResolutionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Guise.clear()
    }

    func testSimpleInstanceRegistration() {
        let xig1 = Xig()
        // Instances are always cached.
        Guise.register(instance: xig1)
        guard let xig2 = Guise.resolve() as Xig? else {
            XCTFail("Instance resolution failed for Xig.")
            return
        }
        XCTAssertNil(Guise.resolve(type: Xig.self, name: "flurb"))
        XCTAssert(xig1 === xig2, "Caching failed.")
    }

    func testNamedInstanceRegistration() {
        let xig1: Upwit = Xig()
        Guise.register(instance: xig1, name: Name.🌈)
        XCTAssertNil(Guise.resolve(type: Upwit.self), "Registration by name failed.")
        guard let xig2: Upwit = Guise.resolve(name: Name.🌈) else {
            XCTFail("Registration by name failed.")
            return
        }
        XCTAssertNil(Guise.resolve(type: Upwit.self, name: UUID()))
        XCTAssert(xig1 === xig2, "Caching failed.")
    }
    
    func testFoo() {
        let xig1: Upwit = Xig()
        Guise.register(weak: xig1)
    }
}
