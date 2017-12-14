//
//  GuiseWeakTests.swift
//  Guise
//
//  Created by Gregory Higley on 12/13/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import XCTest
@testable import Guise

class GuiseWeakTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Guise.clear()
    }

    func testWeakRegistrationAndResolution() {
        var xig: Xig? = Xig()
        Guise.register(weak: xig!) // Never register an optional in Guise.
        XCTAssertNotNil(Guise.resolve(type: Xig.self))
        xig = nil
        XCTAssertNil(Guise.resolve(type: Xig.self))
    }
    
}
