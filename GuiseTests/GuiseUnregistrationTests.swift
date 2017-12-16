//
//  GuiseUnregistrationTests.swift
//  Guise
//
//  Created by Gregory Higley on 12/13/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import XCTest
@testable import Guise

class GuiseUnregistrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Guise.clear()
    }
    
    func testUnregistration() {
        let limit = 4
        var keys = Set<Key<Plonk>>()
        for p in 0..<10 {
            let identifier = UUID()
            let key = Guise.register(factory: Plink(thibb: "\(identifier)") as Plonk, name: identifier)
            if p < limit { keys.insert(key) }
        }
        XCTAssertEqual(limit, keys.count)
        // Now we're going to insert a random key that isn't actually registered
        keys.insert(Key<Plonk>(name: UUID()))
        XCTAssertNotEqual(limit, keys.count)
        XCTAssertEqual(limit, Guise.unregister(keys: keys))
    }
    
    func testUnregistrationOfContainers() {
        let limit = 10
        for _ in 0..<limit {
            let identifier = UUID()
            Guise.register(factory: Plink(thibb: "\(identifier)") as Plonk, name: identifier, container: Container.🐝)
        }
        XCTAssertEqual(limit, Guise.unregister(container: Container.🐝))
    }
    
}
