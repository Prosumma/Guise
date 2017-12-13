//
//  GuiseFilterTests.swift
//  Guise
//
//  Created by Gregory Higley on 10/23/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import XCTest
@testable import Guise

class GuiseFilterTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Guise.clear()
    }
    
    func testFilterByKeys() {
        let key1 = AnyKey(Guise.register(instance: 3, name: Name.🌈))!
        let key2 = AnyKey(type: String.self, container: Container.🐝)
        let found = Guise.filter(keys: [key1, key2]).keys
        XCTAssertEqual(found.count, 1)
        XCTAssertTrue(found.contains(key1))
        XCTAssertFalse(found.contains(key2))
    }

    func testFilterByContainer() {
        let container = Container.🐝
        let key1 = AnyKey(Guise.register(instance: "Fred", name: "fred", container: container))!
        let key2 = AnyKey(Guise.register(instance: Plink(thibb: Guise.resolve(type: String.self, name: "fred", container: container)!) as Plonk, container: container))!
        let key3 = AnyKey(Guise.register(instance: "Fred", name: "fred"))! // Note that this is in the default container, not 🐝
        let found = Set(Guise.filter(container: container).keys)
        XCTAssertEqual(found.count, 2)
        XCTAssertEqual(found.intersection([key1, key2, key3]).count, found.count)
        XCTAssertFalse(found.contains(key3))
    }

    func testFilterByType() {
        let container = Container.🐝, name = Name.🌈
        let key1 = Guise.register(instance: 7, name: name, container: container)
        let key2 = Guise.register(instance: 3, container: container)
        let key3 = Guise.register(instance: 1, name: name)
        Guise.register(instance: "y0", name: name)
        let found = Set(Guise.filter(type: Int.self).keys)
        XCTAssertEqual(found.count, 3)
        XCTAssertEqual(found.intersection([key1, key2, key3]).count, found.count)
    }
}
