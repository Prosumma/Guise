//
//  GuiseTests.swift
//  Guise
//
//  Created by Gregory Higley on 3/12/16.
//  Copyright © 2016 Gregory Higley. All rights reserved.
//

import XCTest
@testable import Guise

class GuiseKeyTests: XCTestCase {
    
    override func tearDown() {
        _ = Guise.clear()
        super.tearDown()
    }
    
    // MARK: Keys
    
    func testFailableKeyConversion() {
        let untypedKey = AnyKey(type: String.self)
        XCTAssertNil(Key<Int>(untypedKey))
    }
    
    func testKeyEqualityForTypedKeys() {
        /*
         Note that for typed keys, the keys must hold the same type, in this case `String.self`.
         This is enforced by the compiler.
         */
        let key1 = Key<String>(name: "Ludwig von Mises")
        let key2 = Key<String>(name: "Murray Rothbard")
        XCTAssertNotEqual(key1, key2)
        let key3 = Key<String>(name: "Ludwig von Mises")
        XCTAssertEqual(key1, key3)
    }
    
    func testKeyEqualityForUntypedKeys() {
        let key1 = AnyKey(type: String.self, name: "Ludwig von Mises")
        let key2 = AnyKey(type: Int.self, name: "Murray Rothbard")
        XCTAssertNotEqual(key1, key2)
        let key3 = AnyKey(type: Int.self, name: "Murray Rothbard")
        XCTAssertEqual(key2, key3)
    }

    func testResolution() {
        let name = UUID() // Any hashable type can be a name, and `UUID` fits the bill.
        _ = Guise.register(instance: "instance", name: name)
        let instance = Guise.resolve(name: name)! as String
        XCTAssertEqual(instance, "instance")
    }
    
}
