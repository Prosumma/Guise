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
    
    func testLazyInjection() {
        Guise.into(injectable: HasALazy.self).inject(\.plonk).register()
        Guise.register(instance: Plink(thibb: Name.owlette.rawValue) as Plonk)
        
        let hasALazy = HasALazy()
        Guise.resolve(into: hasALazy)
        XCTAssertNotNil(hasALazy.plonk)
        XCTAssertEqual(hasALazy.plonk!.value!.thibb, Name.owlette.rawValue)
    }
    
}
