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
        Guise.clear()
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
    
    func testRegistrationOverwritesPreviousRegistrationWithEqualKey() {
        let shpong = "shpong"
        let key1 = Guise.register(factory: Plink(thibb: shpong))
        let plink1 = Guise.resolve(type: Plink.self)!
        XCTAssertEqual(plink1.thibb, shpong)
        let überpickle = "überpickle"
        let key2 = Guise.register(factory: Plink(thibb: überpickle))
        let plink2: Plink = Guise.resolve()!
        XCTAssertNotEqual(shpong, überpickle)
        XCTAssertEqual(plink2.thibb, überpickle) // This proves the registrations are different, because the `thibb` property has a different value.
        XCTAssertNotEqual(plink1.thibb, plink2.thibb)
        XCTAssertEqual(key1, key2) // The keys are the same, so the second registration overwrote the first.
    }
}
