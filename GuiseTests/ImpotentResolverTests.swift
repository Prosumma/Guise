//
//  ImpotentResolverTests.swift
//  Guise
//
//  Created by Gregory Higley on 12/16/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import XCTest
@testable import Guise

class ImpotentResolverTests: XCTestCase {

    func testImpotentResolverResolvesNothingEver() {
        let impotentResolver = ImpotentResolver()
        impotentResolver.register(factory: 3)
        XCTAssertNil(impotentResolver.resolve(type: Int.self))
    }
    
}
