//
//  Filter.swift
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
    
    func filter<Keys: Sequence>(keys: Keys) -> [Keys.Element: Registration] where Keys.Element: Keyed {
        return filter{ keys.contains($0) }
    }
    
    func filter<K: Keyed>(criteria: Criteria) -> [K: Registration] {
        return filter{ $0 ~= criteria }
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
        return resolver.keys
    }
    
    static func filter<K: Keyed & Hashable>(key: K) -> Registration? {
        return resolver.filter(key: key)
    }
    
    static func filter<Keys: Sequence>(keys: Keys) -> [Keys.Element: Registration] where Keys.Element: Keyed {
        return resolver.filter(keys: keys)
    }
    
    static func filter<K: Keyed>(criteria: Criteria) -> [K: Registration] {
        return resolver.filter(criteria: criteria)
    }
    
    static func filter<K: Keyed, Metadata>(criteria: Criteria, metafilter: @escaping Metafilter<Metadata>) -> [K: Registration] {
        return resolver.filter(criteria: criteria, metafilter: metafilter)
    }
    
    static func filter<K: Keyed, Metadata: Equatable>(criteria: Criteria, metadata: Metadata) -> [K: Registration] {
        return resolver.filter(criteria: criteria, metadata: metadata)
    }
    
    static func filter<RegisteredType>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) -> [Key<RegisteredType>: Registration] {
        return resolver.filter(type: type, name: name, container: container)
    }
    
    static func filter<RegisteredType, Metadata>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<Metadata>) -> [Key<RegisteredType>: Registration] {
        return resolver.filter(type: type, name: name, container: container, metafilter: metafilter)
    }
    
    static func filter<RegisteredType, Metadata: Equatable>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: Metadata) -> [Key<RegisteredType>: Registration] {
        return resolver.filter(type: type, name: name, container: container, metadata: metadata)
    }
    
    static func filter(name: AnyHashable? = nil, container: AnyHashable? = nil) -> [AnyKey: Registration] {
        return resolver.filter(name: name, container: container)
    }
    
    static func filter<Metadata>(name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<Metadata>) -> [AnyKey: Registration] {
        return resolver.filter(name: name, container: container, metafilter: metafilter)
    }
    
    static func filter<Metadata: Equatable>(name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: Metadata) -> [AnyKey: Registration] {
        return resolver.filter(name: name, container: container, metadata: metadata)
    }
    
}
