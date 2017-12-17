//
//  GuiseLazyTests.swift
//  Guise
//
//  Created by Gregory Higley on 12/17/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation
import XCTest
@testable import Guise

class GuiseLazyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Guise.clear()
    }
    
    func testLazyStability() {
        Guise.register(factory: Xig())
        let lazyXig = Guise.lazy(type: Xig.self)!
        XCTAssertTrue(lazyXig.resolve()! === lazyXig.resolve()!)
    }
    
    func testLazyResolution() {
        Guise.register(factory: Plink(thibb: "lazy") as Plonk)
        Guise.register{ (resolver: Guising) in TakesALazy(plonk: resolver.lazy()!) }
        let takesALazy: TakesALazy = Guise.resolve()!
        XCTAssertEqual(takesALazy.plonk.thibb, "lazy")
        
    }
    
}
