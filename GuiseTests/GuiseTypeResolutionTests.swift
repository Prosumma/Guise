//
//  GuiseTypeResolutionTests.swift
//  Guise
//
//  Created by Gregory Higley on 10/21/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import XCTest
@testable import Guise

class GuiseTypeResolutionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        _ = Guise.clear()
    }
    
    func testSimpleResolutionByType() {
        _ = Guise.register(type: Xig.self)
        XCTAssertNotNil(Guise.resolve(type: Xig.self))
        XCTAssertNil(Guise.resolve(type: Xig.self, name: Name.🌈))
    }
    
    func testAliasedResolutionByTypeInContainer() {
        _ = Guise.register(type: Upwit.self, impl: Xig.self, container: Container.🐝)
        XCTAssertNotNil(Guise.resolve(type: Upwit.self, container: Container.🐝))
        XCTAssertNil(Guise.resolve(type: Upwit.self, name: Name.🌈, container: Container.🐝))
    }

}
