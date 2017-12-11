//
//  Criteria.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public struct Criteria {
    public let type: String?
    public let name: AnyHashable?
    public let container: AnyHashable?
    
    public init(type: String? = nil, name: AnyHashable? = nil, container: AnyHashable? = nil) {
        self.type = type
        self.name = name
        self.container = container
    }
}

public func ==(lhs: Criteria, rhs: Keyed) -> Bool {
    if let type = lhs.type, type != rhs.type { return false }
    if let name = lhs.name, name != rhs.name { return false }
    if let container = lhs.container, container != rhs.container { return false }
    return true
}

public func ==(lhs: Keyed, rhs: Criteria) -> Bool {
    return rhs == lhs
}

public extension Sequence where Element: Keyed {
    func filter(criteria: Criteria) -> [Element] {
        return filter{ $0 == criteria }
    }
}
