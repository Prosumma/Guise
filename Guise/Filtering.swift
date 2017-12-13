//
//  Filtering.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Guising {
    
    var keys: Set<AnyKey> {
        return Set(filter().keys)
    }
    
    func filter<K: Keyed & Hashable>(key: K) -> Registration? {
        return filter{ $0 == key }.values.first
    }
    
    func filter<K: Keyed>(keys: Set<K>) -> [K: Registration] {
        return filter{ keys.contains($0) }
    }
    
    func filter<K: Keyed>(criteria: Criteria) -> [K: Registration] {
        return filter{ $0 == criteria }
    }
    
    func filter<RegisteredType>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) -> [Key<RegisteredType>: Registration] {
        return filter(criteria: Criteria(name: name, container: container))
    }
    
    func filter(name: AnyHashable? = nil, container: AnyHashable? = nil) -> [AnyKey: Registration] {
        return filter(criteria: Criteria(name: name, container: container))
    }
    
}

public extension _Guise {
    
    static var keys: Set<AnyKey> {
        return defaultResolver.keys
    }
        
    static func filter<K: Keyed & Hashable>(key: K) -> Registration? {
        return defaultResolver.filter(key: key)
    }
    
    static func filter<K: Keyed>(keys: Set<K>) -> [K: Registration] {
        return defaultResolver.filter(keys: keys)
    }
    
    static func filter<K: Keyed>(criteria: Criteria) -> [K: Registration] {
        return defaultResolver.filter(criteria: criteria)
    }
    
    static func filter<RegisteredType>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) -> [Key<RegisteredType>: Registration] {
        return defaultResolver.filter(type: type, name: name, container: container)
    }
    
    static func filter(name: AnyHashable? = nil, container: AnyHashable? = nil) -> [AnyKey: Registration] {
        return defaultResolver.filter(name: name, container: container)
    }
}
