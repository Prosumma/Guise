//
//  Declarations.swift
//  Guise
//
//  Created by Gregory Higley on 9/9/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation
@testable import Guise

enum Name {
    case 🌈 // My daughter chose this rainbow
}

enum Container {
    case 🐝
}

protocol Upwit: class {
    func bnop(x: Int) -> Int
}

final class Xig: Init, Upwit {
    init() {
        
    }
    
    func bnop(x: Int) -> Int {
        return x * 7
    }
}

protocol Plonk {
    var thibb: String { get }
}

struct Plink: Plonk {
    let thibb: String
    
    init(thibb: String) {
        self.thibb = thibb
    }
}

protocol Wibble: class {
    var plonk: Plonk { get }
}

// My daughter named this type. Deal.
class Froufroupookiedingdong: Wibble {
    let plonk: Plonk
    
    init(plonk: Plonk) {
        self.plonk = plonk
    }
}

