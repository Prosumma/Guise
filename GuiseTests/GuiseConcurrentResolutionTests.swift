//
//  GuiseConcurrentResolutionTests.swift
//  Guise
//
//  Created by Gregory Higley on 10/22/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import XCTest
@testable import Guise

class GuiseConcurrentResolutionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        _ = Guise.clear()
    }

    // This test is probably worthless, but it can't hurt.
    // I'm not really sure exactly how to test this.
    func testConcurrentResolution() {
        let queue = DispatchQueue.global()
        
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        
        let wob = "wob"
        
        _ = Guise.register(factory: Plink(thibb: wob) as Plonk, container: Container.🐝)
        _ = Guise.register(factory: Froufroupookiedingdong(plonk: Guise.resolve(container: Container.🐝)!) as Wibble, name: Name.🌈)
        
        queue.async {
            let wibble = Guise.resolve(type: Wibble.self, name: Name.🌈)!
            XCTAssertEqual(wibble.plonk.thibb, wob)
            expectation1.fulfill()
        }
        
        queue.async {
            _ = Guise.resolve(container: Container.🐝)! as Plonk
            let wibble = Guise.resolve(type: Wibble.self, name: Name.🌈)!
            XCTAssertEqual(wibble.plonk.thibb, wob)
            expectation2.fulfill()
        }
        
        wait(for: [expectation1, expectation2], timeout: 10.0)
    }

}
