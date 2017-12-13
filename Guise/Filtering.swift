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
    
    func filter<K: Keyed, Metadata>(criteria: Criteria, metafilter: @escaping Metafilter<Metadata>) -> [K: Registration] {
        return filter(criteria: criteria).filter(metathunk(metafilter))
    }
    
    func filter<K: Keyed, Metadata: Equatable>(criteria: Criteria, metadata: Metadata) -> [K: Registration] {
        return filter(criteria: criteria) { $0 == metadata }
    }
    
    func filter<RegisteredType>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) -> [Key<RegisteredType>: Registration] {
        return filter(criteria: Criteria(name: name, container: container))
    }
    
    func filter<RegisteredType, Metadata>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<Metadata>) -> [Key<RegisteredType>: Registration] {
        return filter(criteria: Criteria(name: name, container: container)).filter(metathunk(metafilter))
    }
    
    func filter<RegisteredType, Metadata: Equatable>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: Metadata) -> [Key<RegisteredType>: Registration] {
        return filter(type: type, name: name, container: container) { $0 == metadata }
    }
    
    func filter(name: AnyHashable? = nil, container: AnyHashable? = nil) -> [AnyKey: Registration] {
        return filter(criteria: Criteria(name: name, container: container))
    }
    
    func filter<Metadata>(name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<Metadata>) -> [AnyKey: Registration] {
        return filter(criteria: Criteria(name: name, container: container)).filter(metathunk(metafilter))
    }
    
    func filter<Metadata: Equatable>(name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: Metadata) -> [AnyKey: Registration] {
        return filter(name: name, container: container) { $0 == metadata }
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
    
    static func filter<K: Keyed, Metadata>(criteria: Criteria, metafilter: @escaping Metafilter<Metadata>) -> [K: Registration] {
        return defaultResolver.filter(criteria: criteria, metafilter: metafilter)
    }
    
    static func filter<K: Keyed, Metadata: Equatable>(criteria: Criteria, metadata: Metadata) -> [K: Registration] {
        return defaultResolver.filter(criteria: criteria, metadata: metadata)
    }
    
    static func filter<RegisteredType>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) -> [Key<RegisteredType>: Registration] {
        return defaultResolver.filter(type: type, name: name, container: container)
    }
    
    static func filter<RegisteredType, Metadata>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<Metadata>) -> [Key<RegisteredType>: Registration] {
        return defaultResolver.filter(type: type, name: name, container: container, metafilter: metafilter)
    }
    
    static func filter<RegisteredType, Metadata: Equatable>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: Metadata) -> [Key<RegisteredType>: Registration] {
        return defaultResolver.filter(type: type, name: name, container: container, metadata: metadata)
    }
    
    static func filter(name: AnyHashable? = nil, container: AnyHashable? = nil) -> [AnyKey: Registration] {
        return defaultResolver.filter(name: name, container: container)
    }
    
    static func filter<Metadata>(name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<Metadata>) -> [AnyKey: Registration] {
        return defaultResolver.filter(name: name, container: container, metafilter: metafilter)
    }
    
    static func filter<Metadata: Equatable>(name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: Metadata) -> [AnyKey: Registration] {
        return defaultResolver.filter(name: name, container: container, metadata: metadata)
    }
}
