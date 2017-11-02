//
//  Criterion.swift
//  Guise
//
//  Created by Gregory Higley on 11/1/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/// Represents a filter criterion
public struct Criterion: Hashable {
    public let type: String?
    public let name: AnyHashable?
    public let container: AnyHashable?
    public let hashValue: Int
    
    public init<T>(type: T.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) {
        self.type = String(reflecting: T.self)
        self.name = name
        self.container = container
        self.hashValue = hash(String(reflecting: Criterion.self), self.type, self.name, self.container)
    }
    
    public init(name: AnyHashable? = nil, container: AnyHashable? = nil) {
        self.type = nil
        self.name = name
        self.container = container
        self.hashValue = hash(String(reflecting: Criterion.self), self.type, self.name, self.container)
    }
    
    public init<K: Keyed>(_ key: K) {
        self.type = key.type
        self.name = key.name
        self.container = key.container
        self.hashValue = hash(String(reflecting: Criterion.self), self.type, self.name, self.container)
    }
    
    public func matches<K: Keyed>(key: K) -> Bool {
        if let type = type, key.type != type { return false }
        if let name = name, key.name != name { return false }
        if let container = container, key.container != container { return false }
        return true
    }
}

public extension Sequence where Element == Criterion {
    func matches<K: Keyed>(key: K) -> Bool {
        for criterion in self {
            if criterion.matches(key: key) { return true }
        }
        return false
    }
}

public func ==(lhs: Criterion, rhs: Criterion) -> Bool {
    return lhs.hashValue == rhs.hashValue && lhs.type == rhs.type && lhs.name == rhs.name && lhs.container == rhs.container
}
