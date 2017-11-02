//
//  Filter.swift
//  Guise
//
//  Created by Gregory Higley on 9/3/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolver {
    /**
     Match by filter criteria and optional metafilter.
     
     - parameter criteria: The filter criteria to match
     - parameter metafilter: The metafilter query to apply
     
     - returns: The matched keys
     */
    public func filter<K: Keyed & Hashable>(criteria: Set<Criterion>, metafilter: Metafilter<Any>?) -> Set<K> {
        var matches = lock.read({ registrations.filter{ criteria.matches(key: $0.key) } })
        if let metafilter = metafilter {
            matches = matches.filter{ metafilter($0.value.metadata) }
        }
        return Set(matches.keys.flatMap(K.init))
    }
}

public extension Resolving {
// MARK: - Filter By Keys
    
    /**
     Return those keys in `keys` which are registered with Guise.
     
     - parameter keys: The keys to find
     - returns: The matched keys
     */
    func filter<K: Keyed>(keys: Set<K>) -> Set<K> {
        return filter(criteria: Set(keys.map(Criterion.init)), metafilter: nil)
    }
    
    /**
     Return those keys in `keys` which are registered with Guise and pass the metadata filter.
     
     - parameter keys: The keys to find
     - parameter metafilter: The metafilter query to apply
     
     - returns: The matched keys
     */
    public func filter<K: Keyed, M>(keys: Set<K>, metafilter: @escaping Metafilter<M>) -> Set<K> {
        return filter(criteria: Set(keys.map(Criterion.init)), metafilter: metathunk(metafilter))
    }
    
    /**
     Return those keys in `keys` which are registered with Guise and whose metadata is equal to `metadata`.
     
     - parameter keys: The keys to find
     - parameter metadata: The `Equatable` metadata to match
     
     - returns: The matched keys
     */
    public func filter<K: Keyed, M: Equatable>(keys: Set<K>, metadata: M) -> Set<K> {
        return filter(keys: keys) { $0 == metadata }
    }
    
    // MARK: - Filter By Type, Name, Container
    
    /**
     Find keys matching the given criteria.
     
     - parameter type: The registered type
     - parameter name: The registered name
     - parameter container: The registered container
     
     - returns: The matched keys
     
     - warning: The `name` and `container` parameters are optional. In other contexts,
     an optional `name` or `container` implicitly references the default name or container,
     but in this case, it means _any_ name or container.
     */
    public func filter<T>(type: T.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) -> Set<Key<T>> {
        let criterion = Criterion(type: type, name: name, container: container)
        return filter(criteria: [criterion], metafilter: nil)
    }
    
    /**
     Find keys matching the given criteria and metadata filter.
     
     - parameter type: The registered type
     - parameter name: The registered name
     - parameter container: The registered container
     - parameter metafilter: The metafilter query to apply
     
     - returns: The matched keys
     
     - warning: The `name` and `container` parameters are optional. In other contexts,
     an optional `name` or `container` implicitly references the default name or container,
     but in this case, it means _any_ name or container.
     */
    public func filter<T, M>(type: T.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<M>) -> Set<Key<T>> {
        let criterion = Criterion(type: type, name: name, container: container)
        return filter(criteria: [criterion], metafilter: metathunk(metafilter))
    }
    
    /**
     Find keys matching the given criteria and metadata.
     
     - parameter type: The registered type
     - parameter name: The registered name
     - parameter container: The registered container
     - parameter metadata: The `Equatable` metadata to match
     
     - returns: The matched keys
     
     - warning: The `name` and `container` parameters are optional. In other contexts,
     an optional `name` or `container` implicitly references the default name or container,
     but in this case, it means _any_ name or container.
     */
    public func filter<T, M: Equatable>(type: T.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: M) -> Set<Key<T>> {
        return filter(type: type, name: name, container: container) { $0 == metadata }
    }
    
    /**
     Find keys matching the given criteria.
     
     - parameter name: The registered name
     - parameter container: The registered container
     
     - returns: The matched keys
     
     - warning: The `name` and `container` parameters are optional. In other contexts,
     an optional `name` or `container` implicitly references the default name or container,
     but in this case, it means _any_ name or container.
     */
    public func filter(name: AnyHashable? = nil, container: AnyHashable? = nil) -> Set<AnyKey> {
        let criterion = Criterion(name: name, container: container)
        return filter(criteria: [criterion], metafilter: nil)
    }
    
    /**
     Find keys matching the given criteria and metadata filter.
     
     - parameter name: The registered name
     - parameter container: The registered container
     - parameter metafilter: The metafilter query to apply
     
     - returns: The matched keys
     
     - warning: The `name` and `container` parameters are optional. In other contexts,
     an optional `name` or `container` implicitly references the default name or container,
     but in this case, it means _any_ name or container.
     */
    public func filter<M>(name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<M>) -> Set<AnyKey> {
        let criterion = Criterion(name: name, container: container)
        return filter(criteria: [criterion], metafilter: metathunk(metafilter))
    }
    
    /**
     Find keys matching the given criteria and metadata.
     
     - parameter name: The registered name
     - parameter container: The registered container
     - parameter metadata: The `Equatable` metadata to match
     
     - returns: The matched keys
     
     - warning: The `name` and `container` parameters are optional. In other contexts,
     an optional `name` or `container` implicitly references the default name or container,
     but in this case, it means _any_ name or container.
     */
    public func filter<M: Equatable>(name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: M) -> Set<AnyKey> {
        return filter(name: name, container: container) { $0 == metadata }
    }

}

public extension Guise {
// MARK: - Filter By Criteria
    
    static func filter<K: Keyed>(criteria: Set<Criterion>, metafilter: Metafilter<Any>? = nil) -> Set<K> {
        return defaultResolver.filter(criteria: criteria, metafilter: metafilter)
    }
    
// MARK: - Filter By Keys
    
    /**
     Return those keys in `keys` which are registered with Guise.
     
     - parameter keys: The keys to find
     - returns: The matched keys
     */
    static func filter<K: Keyed>(keys: Set<K>) -> Set<K> {
        return defaultResolver.filter(keys: keys)
    }
    
    /**
     Return those keys in `keys` which are registered with Guise and pass the metadata filter.
     
     - parameter keys: The keys to find
     - parameter metafilter: The metafilter query to apply
     
     - returns: The matched keys
     */
    static func filter<K: Keyed, M>(keys: Set<K>, metafilter: @escaping Metafilter<M>) -> Set<K> {
        return defaultResolver.filter(keys: keys, metafilter: metafilter)
    }
    
    /**
     Return those keys in `keys` which are registered with Guise and whose metadata is equal to `metadata`.
     
     - parameter keys: The keys to find
     - parameter metadata: The `Equatable` metadata to match
     
     - returns: The matched keys
     */
    static func filter<K: Keyed, M: Equatable>(keys: Set<K>, metadata: M) -> Set<K> {
        return defaultResolver.filter(keys: keys, metadata: metadata)
    }

// MARK: - Filter By Type, Name, Container
    
    /**
     Find keys matching the given criteria.
     
     - parameter type: The registered type
     - parameter name: The registered name
     - parameter container: The registered container
     
     - returns: The matched keys
     
     - warning: The `name` and `container` parameters are optional. In other contexts,
     an optional `name` or `container` implicitly references the default name or container,
     but in this case, it means _any_ name or container.
     */
    static func filter<T>(type: T.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) -> Set<Key<T>> {
        return defaultResolver.filter(type: type, name: name, container: container)
    }
    
    /**
     Find keys matching the given criteria and metadata filter.
     
     - parameter type: The registered type
     - parameter name: The registered name
     - parameter container: The registered container
     - parameter metafilter: The metafilter query to apply
     
     - returns: The matched keys
     
     - warning: The `name` and `container` parameters are optional. In other contexts,
     an optional `name` or `container` implicitly references the default name or container,
     but in this case, it means _any_ name or container.
     */
    static func filter<T, M>(type: T.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<M>) -> Set<Key<T>> {
        return defaultResolver.filter(type: type, name: name, container: container, metafilter: metafilter)
    }

    /**
     Find keys matching the given criteria and metadata.
     
     - parameter type: The registered type
     - parameter name: The registered name
     - parameter container: The registered container
     - parameter metadata: The `Equatable` metadata to match
     
     - returns: The matched keys
     
     - warning: The `name` and `container` parameters are optional. In other contexts,
     an optional `name` or `container` implicitly references the default name or container,
     but in this case, it means _any_ name or container.
     */
    static func filter<T, M: Equatable>(type: T.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: M) -> Set<Key<T>> {
        return defaultResolver.filter(type: type, name: name, container: container, metadata: metadata)
    }
    
    /**
     Find keys matching the given criteria.
     
     - parameter name: The registered name
     - parameter container: The registered container
     
     - returns: The matched keys
     
     - warning: The `name` and `container` parameters are optional. In other contexts,
     an optional `name` or `container` implicitly references the default name or container,
     but in this case, it means _any_ name or container.
     */
    static func filter(name: AnyHashable? = nil, container: AnyHashable? = nil) -> Set<AnyKey> {
        return defaultResolver.filter(name: name, container: container)
    }
    
    /**
     Find keys matching the given criteria and metadata filter.
     
     - parameter name: The registered name
     - parameter container: The registered container
     - parameter metafilter: The metafilter query to apply
     
     - returns: The matched keys
     
     - warning: The `name` and `container` parameters are optional. In other contexts,
     an optional `name` or `container` implicitly references the default name or container,
     but in this case, it means _any_ name or container.
     */
    static func filter<M>(name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<M>) -> Set<AnyKey> {
        return defaultResolver.filter(name: name, container: container, metafilter: metafilter)
    }
    
    /**
     Find keys matching the given criteria and metadata.
     
     - parameter name: The registered name
     - parameter container: The registered container
     - parameter metadata: The `Equatable` metadata to match
     
     - returns: The matched keys
     
     - warning: The `name` and `container` parameters are optional. In other contexts,
     an optional `name` or `container` implicitly references the default name or container,
     but in this case, it means _any_ name or container.
     */
    static func filter<M: Equatable>(name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: M) -> Set<AnyKey> {
        return defaultResolver.filter(name: name, container: container, metadata: metadata)
    }

}
