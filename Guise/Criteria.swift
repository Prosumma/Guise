//
//  Criteria.swift
//  Guise
//
//  Created by Gregory Higley on 12/12/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public typealias Criteria = (name: AnyHashable?, container: AnyHashable?)

public func ==(lhs: Keyed, rhs: Criteria) -> Bool {
    if let name = rhs.name, lhs.name != name { return false }
    if let container = rhs.container, lhs.container != container { return false }
    return true
}

public func ==(lhs: Criteria, rhs: Keyed) -> Bool {
    return rhs == lhs
}
