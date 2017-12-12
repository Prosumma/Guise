//
//  Keyed.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public protocol Keyed {
    var type: String { get }
    var name: AnyHashable { get }
    var container: AnyHashable { get }
    init?(_ key: Keyed)
}

public func ==(lhs: Keyed, rhs: Keyed) -> Bool {
    return lhs.type == rhs.type && lhs.name == rhs.name && lhs.container == rhs.container
}

public func ==<K: Keyed>(lhs: K, rhs: K) -> Bool {
    return lhs.type == rhs.type && lhs.name == rhs.name && lhs.container == rhs.container
}
