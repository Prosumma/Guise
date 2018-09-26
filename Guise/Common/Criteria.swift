//
//  Criteria.swift
//  Guise
//
//  Created by Gregory Higley on 12/12/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 A convenience type used in `filter` overloads.
 
 Its chief claim to fame is that the pattern match operator
 `~=` is defined such that a `Criteria` and a `Keyed` instance
 can be compared.
 
 Types are excluded because they are matched using the failable
 initializer of the `Keyed` protocol. (See the implementation of
 `filter` in the `Resolver` class.)
 */
public typealias Criteria = (name: AnyHashable?, container: AnyHashable?)

public func ~=(lhs: Keyed, rhs: Criteria) -> Bool {
    if let name = rhs.name, lhs.name != name { return false }
    if let container = rhs.container, lhs.container != container { return false }
    return true
}

public func ~=(lhs: Criteria, rhs: Keyed) -> Bool {
    return rhs ~= lhs
}
