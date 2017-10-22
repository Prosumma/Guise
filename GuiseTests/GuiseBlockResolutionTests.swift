//
//  GuiseResolutionTests.swift
//  Guise
//
//  Created by Gregory Higley on 10/21/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import XCTest
@testable import Guise

class GuiseBlockResolutionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        _ = Guise.clear()
    }
    
    func testResolveBlock() {
        let parameter = "gshob"
        _ = Guise.register{ Plink(thibb: parameter) as Plonk }
        guard let plonk: Plonk = Guise.resolve() else {
            XCTFail("Unable to resolve Plink as Plonk.")
            return
        }
        XCTAssertEqual(plonk.thibb, parameter)
    }
    
    func testResolveBlockWithParameter() {
        let parameter = "squibbit"
        _ = Guise.register{ Plink(thibb: $0) as Plonk }
        guard let plonk: Plonk = Guise.resolve(parameter: parameter) else {
            XCTFail("Unable to resolve Plink as Plonk with parameter.")
            return
        }
        XCTAssertEqual(plonk.thibb, parameter)
    }

    func testResolveBlockWithCompositionAndCaching() {
        let parameter = "thuzb"
        _ = Guise.register(factory: Plink(thibb: parameter) as Plonk)
        // This should really be done with Guise.register(instance:), which uses an autoclosure
        // to evaluate lazily, but I wanted to show the "underlying" syntax.
        _ = Guise.register(cached: true) { Froufroupookiedingdong(plonk: Guise.resolve()!) as Wibble }
        guard let wibble1 = Guise.resolve(type: Wibble.self) else {
            XCTFail("Unable to resolve Froufroupookiedingdong as Wibble.")
            return
        }
        XCTAssertEqual(wibble1.plonk.thibb, parameter)
        guard let wibble2: Wibble = Guise.resolve() else {
            XCTFail("Unable to resolve Froufroupookiedingdong as Wibble.")
            return
        }
        XCTAssert(wibble1 === wibble2, "Caching failed.")
    }
    
}
