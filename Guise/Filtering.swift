//
//  Filtering.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Guising {
    
    func filter<K: Keyed>(key: K.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) -> [K: Registration] {
        return filter(key: key, name: name, container: container)
    }
    
    func filter<RegisteredType>(key: Key<RegisteredType>) -> Registration? {
        return filter(type: RegisteredType.self, name: key.name, container: key.container).values.first
    }
    
    func filter<RegisteredType>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) -> [Key<RegisteredType>: Registration] {
        return filter(key: Key<RegisteredType>.self, name: name, container: container)
    }
    
    func filter<RegisteredType, Metadata>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<Metadata>) -> [Key<RegisteredType>: Registration] {
        return filter(type: type, name: name, container: container).filter(metathunk(metafilter))
    }
    
    func filter<RegisteredType, Metadata: Equatable>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: Metadata) -> [Key<RegisteredType>: Registration] {
        return filter(type: type, name: name, container: container) { $0 == metadata }
    }
    
    func filter(name: AnyHashable? = nil, container: AnyHashable? = nil) -> [AnyKey: Registration] {
        return filter(key: AnyKey.self, name: name, container: container)
    }
    
    func filter<Metadata>(name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<Metadata>) -> [AnyKey: Registration] {
        return filter(name: name, container: container).filter(metathunk(metafilter))
    }
    
    func filter<Metadata: Equatable>(name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: Metadata) -> [AnyKey: Registration] {
        return filter(name: name, container: container) { $0 == metadata }
    }
}

public extension _Guise {

    static func filter<K: Keyed>(key: K.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) -> [K: Registration] {
        return filter(key: key, name: name, container: container)
    }
    
    static func filter<RegisteredType>(key: Key<RegisteredType>) -> Registration? {
        return filter(type: RegisteredType.self, name: key.name, container: key.container).values.first
    }
    
    static func filter<RegisteredType>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) -> [Key<RegisteredType>: Registration] {
        return filter(key: Key<RegisteredType>.self, name: name, container: container)
    }
    
    static func filter<RegisteredType, Metadata>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<Metadata>) -> [Key<RegisteredType>: Registration] {
        return filter(type: type, name: name, container: container).filter(metathunk(metafilter))
    }
    
    static func filter<RegisteredType, Metadata: Equatable>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: Metadata) -> [Key<RegisteredType>: Registration] {
        return filter(type: type, name: name, container: container) { $0 == metadata }
    }
    
    static func filter(name: AnyHashable? = nil, container: AnyHashable? = nil) -> [AnyKey: Registration] {
        return filter(key: AnyKey.self, name: name, container: container)
    }
    
    static func filter<Metadata>(name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<Metadata>) -> [AnyKey: Registration] {
        return filter(name: name, container: container).filter(metathunk(metafilter))
    }
    
    static func filter<Metadata: Equatable>(name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: Metadata) -> [AnyKey: Registration] {
        return filter(name: name, container: container) { $0 == metadata }
    }
}
