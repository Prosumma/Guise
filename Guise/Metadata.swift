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

public func metathunk<M>(_ metafilter: @escaping Metafilter<M>) -> Metafilter<Any> {
    return {
        guard let metadata = $0 as? M else { return false }
        return metafilter(metadata)
    }
}

// MARK: -

public extension Resolver {
    /**
     Retrieve metadata for the given key.
     
     The `type` parameter does not have to be exactly the same as the type
     of the registered metadata. It simply has to be type-compatible. If it is
     not, `nil` is returned.
     
     - parameter key: The key for which to retrieve the metadata
     - parameter metatype: The type of the metadata to retrieve
     
     - returns: The metadata or `nil` if it is not found
     */
    func metadata<K: Keyed, M>(forKey key: K, metatype: M.Type = M.self) -> M? {
        let key = AnyKey(key)!
        guard let dependency = lock.read({ registrations[key] }) else { return nil }
        return dependency.metadata as? M
    }
}

// MARK: -

public extension Resolving {
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
    func metadata<T, M>(forType type: T.Type, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metatype: M.Type = M.self) -> M? {
        return metadata(forKey: Key<T>(name: name, container: container), metatype: metatype)
    }

}

// MARK: -

public extension Guise {
    
    /**
     Retrieve metadata for the given key.
     
     The `type` parameter does not have to be exactly the same as the type
     of the registered metadata. It simply has to be type-compatible. If it is
     not, `nil` is returned.
     
     - parameter key: The key for which to retrieve the metadata
     - parameter metatype: The type of the metadata to retrieve
     
     - returns: The metadata or `nil` if it is not found
     */
    static func metadata<K: Keyed, M>(forKey key: K, metatype: M.Type = M.self) -> M? {
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
    static func metadata<T, M>(forType type: T.Type, name: AnyHashable = Name.default, container: AnyHashable = Container.default, metatype: M.Type = M.self) -> M? {
        return defaultResolver.metadata(forType: type, name: name, container: container, metatype: metatype)
    }
    
}
