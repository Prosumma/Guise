//
//  Filter.swift
//  Guise
//
//  Created by Gregory Higley on 9/3/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

extension Resolver {
// MARK: - Filter By Keys
    
    /// All roads lead here
    private func filter<K: Keyed>(keys: Set<K>, metathunk: Metathunk?) -> Set<K> {
        let keys = keys.map{ AnyKey($0)! }
        let matched = lock.read{ registrations.filter{ keys.contains($0.key) } }
        var matchedKeys = matched.keys
        if let metathunk = metathunk {
            matchedKeys = matched.filter{ metathunk($0.value.metadata) }.keys
        }
        return Set(matchedKeys.flatMap{ K($0) })
    }

    /**
     Return those keys in `keys` which are registered with Guise.
     
     - parameter keys: The keys to find
     - returns: The matched keys
     */
    public func filter<K: Keyed>(keys: Set<K>) -> Set<K> {
        return filter(keys: keys, metathunk: nil)
    }
    
    /**
     Return those keys in `keys` which are registered with Guise and pass the metadata filter.
     
     - parameter keys: The keys to find
     - parameter metafilter: The metafilter query to apply
     
     - returns: The matched keys
     */
    public func filter<K: Keyed, M>(keys: Set<K>, metafilter: @escaping Metafilter<M>) -> Set<K> {
        return filter(keys: keys, metathunk: metathunk(metafilter))
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
    
    /// All roads lead here
    private func filter<K: Keyed & Hashable>(name: AnyHashable?, container: AnyHashable?, metathunk: Metathunk?) -> Set<K> {
        let keymap: (Dictionary<AnyKey, Registration>.Element) -> Dictionary<K, Registration>.Element? = {
            /*
             Filtering by type occurs when `K` is `Key<T>`. For instance, if `K` is `Key<String>` but `$0.key.type` is
             `Swift.Int`, the initializer will fail because of the type incompatibility. This is why no explicit `type`
             parameter for this method is needed.
             
             When *not* filtering by type, `K` should be `AnyKey`.
             */
            guard let key = K($0.key) else { return nil }
            if let name = name, name != key.name { return nil }
            if let container = container, container != key.container { return nil }
            return (key: key, value: $0.value)
        }
        var matched = lock.read{ registrations.flatMap(keymap) }.dictionary()
        if let metathunk = metathunk {
            matched = matched.filter{ metathunk($0.value.metadata) }
        }
        return Set(matched.keys)
    }
    
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
        return filter(name: name, container: container, metathunk: nil)
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
        return filter(name: name, container: container, metathunk: metathunk(metafilter))
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
        return filter(name: name, container: container, metathunk: nil)
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
        return filter(name: name, container: container, metathunk: metathunk(metafilter))
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

extension Guise {
// MARK: - Filter By Keys
    
    /**
     Return those keys in `keys` which are registered with Guise.
     
     - parameter keys: The keys to find
     - returns: The matched keys
     */
    public static func filter<K: Keyed>(keys: Set<K>) -> Set<K> {
        return defaultResolver.filter(keys: keys)
    }
    
    /**
     Return those keys in `keys` which are registered with Guise and pass the metadata filter.
     
     - parameter keys: The keys to find
     - parameter metafilter: The metafilter query to apply
     
     - returns: The matched keys
     */
    public static func filter<K: Keyed, M>(keys: Set<K>, metafilter: @escaping Metafilter<M>) -> Set<K> {
        return defaultResolver.filter(keys: keys, metafilter: metafilter)
    }
    
    /**
     Return those keys in `keys` which are registered with Guise and whose metadata is equal to `metadata`.
     
     - parameter keys: The keys to find
     - parameter metadata: The `Equatable` metadata to match
     
     - returns: The matched keys
     */
    public static func filter<K: Keyed, M: Equatable>(keys: Set<K>, metadata: M) -> Set<K> {
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
    public static func filter<T>(type: T.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) -> Set<Key<T>> {
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
    public static func filter<T, M>(type: T.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<M>) -> Set<Key<T>> {
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
    public static func filter<T, M: Equatable>(type: T.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: M) -> Set<Key<T>> {
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
    public static func filter(name: AnyHashable? = nil, container: AnyHashable? = nil) -> Set<AnyKey> {
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
    public static func filter<M>(name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<M>) -> Set<AnyKey> {
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
    public static func filter<M: Equatable>(name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: M) -> Set<AnyKey> {
        return defaultResolver.filter(name: name, container: container, metadata: metadata)
    }

}
