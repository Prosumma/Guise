//
//  Miscellanea.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

func hash(_ hashables: AnyHashable?...) -> Int {
    // djb2 hash algorithm: http://www.cse.yorku.ca/~oz/hash.html
    // &+ operator handles Int overflow
    return hashables.compactMap{ $0 }.reduce(5381) { (result, hashable) in ((result << 5) &+ result) &+ hashable.hashValue }
}
