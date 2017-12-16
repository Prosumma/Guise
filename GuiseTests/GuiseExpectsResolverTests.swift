//
//  GuiseExpectsResolverTests.swift
//  Guise
//
//  Created by Gregory Higley on 12/16/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import XCTest
@testable import Guise

class GuiseExpectsResolverTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Guise.clear()
    }

    func testExpectsResolver() {
        Guise.register(factory: Plink(thibb: "wibble") as Plonk, name: Name.🌈)
        Guise.register{ (resolver: Guising) in
            return Froufroupookiedingdong(plonk: resolver.resolve(name: Name.🌈)!) as Wibble
        }
        let wibble = Guise.resolve(type: Wibble.self)!
        XCTAssertEqual(wibble.plonk.thibb, "wibble")
    }
    
}
