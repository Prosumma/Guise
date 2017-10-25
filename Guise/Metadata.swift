//
//  Metadata.swift
//  Guise
//
//  Created by Gregory Higley on 9/4/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/// The type of a metadata predicate.
public typealias Metafilter<M> = (M) -> Bool

/**
 Used in filters and resolution.
 
 This type exists primarily to emphasize that the `metathunk` method should be applied to
 `Metafilter<M>` before the metafilter is passed to the master `filter` or `exists` method.
 */
typealias Metathunk = Metafilter<Any>

func metathunk<M>(_ metafilter: @escaping Metafilter<M>) -> Metathunk {
    return {
        guard let metadata = $0 as? M else { return false }
        return metafilter(metadata)
    }
}

extension DependencyResolver {
    /**
     Retrieve metadata for the given key.
     
     The `type` parameter does not have to be exactly the same as the type
     of the registered metadata. It simply has to be type-compatible. If it is
     not, `nil` is returned.
     
     - parameter key: The key for which to retrieve the metadata
     - parameter metatype: The type of the metadata to retrieve
     
     - returns: The metadata or `nil` if it is not found
     */
    public func metadata<K: Keyed, M>(forKey key: K, metatype: M.Type = M.self) -> M? {
        let key = AnyKey(key)!
        guard let dependency = lock.read({ registrations[key] }) else { return nil }
        return dependency.metadata as? M
    }
    
    /**
     Retrieve metadata for the given key.
     
     The `type` parameter does not have to be exactly the same as the type
     of the registered metadata. It simply has to be type-compatible. If it is not,
     `nil` is returned.
     
     - parameter type: The registered type for which to retrieve the metadata
     - parameter name: The name of the registration for which to retrieve the metadata
     - parameter container: The container of the registraton for which to retrieve the metadata
     - parameter metatype: The type of the metadata to retrieve
     
     - returns: The metadata or `nil` if it is not found
     */
    public func metadata<T, M>(forType type: T.Type, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metatype: M.Type = M.self) -> M? {
        return metadata(forKey: Key<T>(name: name, container: container))
    }

}

// MARK: -

extension Guise {
    
    /**
     Retrieve metadata for the given key.
     
     The `type` parameter does not have to be exactly the same as the type
     of the registered metadata. It simply has to be type-compatible. If it is
     not, `nil` is returned.
     
     - parameter key: The key for which to retrieve the metadata
     - parameter metatype: The type of the metadata to retrieve
     
     - returns: The metadata or `nil` if it is not found
     */
    public static func metadata<K: Keyed, M>(forKey key: K, metatype: M.Type = M.self) -> M? {
        return defaultResolver.metadata(forKey: key, metatype: metatype)
    }
    
    /**
     Retrieve metadata for the given key.
     
     The `type` parameter does not have to be exactly the same as the type
     of the registered metadata. It simply has to be type-compatible. If it is not,
     `nil` is returned.
     
     - parameter type: The registered type for which to retrieve the metadata
     - parameter name: The name of the registration for which to retrieve the metadata
     - parameter container: The container of the registraton for which to retrieve the metadata
     - parameter metatype: The type of the metadata to retrieve
     
     - returns: The metadata or `nil` if it is not found
     */
    public static func metadata<T, M>(forType type: T.Type, name: AnyHashable = Name.default, container: AnyHashable = Container.default, metatype: M.Type = M.self) -> M? {
        return defaultResolver.metadata(forType: type, name: name, container: container, metatype: metatype)
    }
    
}
