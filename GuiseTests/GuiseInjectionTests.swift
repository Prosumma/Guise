//
//  GuiseInjectionTests.swift
//  Guise
//
//  Created by Gregory Higley on 12/12/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import XCTest
@testable import Guise

class GuiseInjectionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Guise.clear()
    }

    func testInjection() {
        Guise.register(factory: Xig() as Upwit)
        Guise.register(factory: Plink(thibb: Name.owlette.rawValue) as Plonk, name: Name.owlette)
        Guise.into(injectable: Owlette.self)
            .inject(\.upwit)
            .inject(\.plonk, name: Name.owlette)
            .register()
        
        let owlette = Owlette()
        XCTAssertNil(owlette.upwit)
        XCTAssertNil(owlette.plonk)
        
        Guise.resolve(into: owlette)
        XCTAssertNotNil(owlette.upwit)
        XCTAssertNotNil(owlette.plonk)
        XCTAssertEqual(owlette.plonk!.thibb, Name.owlette.rawValue)
    }
    
    func testInjectionWithMultipleProtocols() {
        Guise.register(instance: "Multi1")
        Guise.register(instance: 7)
        
        Guise.into(injectable: Multi1.self).inject(\.s).register()
        Guise.into(injectable: Multi2.self).inject(exact: \.x).register()
        
        let m = Guise.resolve(into: Multi())
        XCTAssertNotNil(m.s)
        XCTAssertEqual(m.s!, "Multi1")
        XCTAssertEqual(m.x, 7)
    }
    
}
