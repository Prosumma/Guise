//
//  Declarations.swift
//  Guise
//
//  Created by Gregory Higley on 9/9/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation
@testable import Guise

/**
 Simple enumerations are hashable by default in Swift.
 This means they will convert automatically to `AnyHashable`
 
 While I recommend using an enumeration, you don't have to.
 _Any_ hashable type can be used for the `name` and `container`
 of a registration.
 */
enum Name: String {
    case 🌈 // My daughter chose this rainbow
    case owlette
}

/**
 Simple enumerations are hashable by default in Swift.
 This means they will convert automatically to `AnyHashable`
 
 While I recommend using an enumeration, you don't have to.
 _Any_ hashable type can be used for the `name` and `container`
 of a registration.
 */
enum Container {
    case 🐝
    case 💣
}

protocol Upwit: class {
    func bnop(x: Int) -> Int
}

final class Xig: Upwit {
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

/*
 My 4-year-old daughter named this type.
 Well done.
*/
class Froufroupookiedingdong: Wibble {
    let plonk: Plonk
    
    init(plonk: Plonk) {
        self.plonk = plonk
    }
}

class Owlette {
    var upwit: Upwit!
    var plonk: Plonk?
}

struct TakesALazy {
    let plonk: Plonk
    init(plonk: Lazy<Plonk>) {
        self.plonk = plonk.resolve()!
    }
}

class HasALazy {
    var plonk: Lazy<Plonk>?
}

enum Metadata {
    case blah
    case bloop
    case blee
}

protocol Multi1 {
    var s: String? { get set }
}

protocol Multi2 {
    var x: Int { get set }
}

struct Multi: Multi1, Multi2 {
    var s: String? = nil
    var x: Int = 0
}
