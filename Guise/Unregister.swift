//
//  Unregister.swift
//  Guise
//
//  Created by Gregory Higley on 9/3/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolver {
    /**
     Remove registrations by key.
     
     - parameter keys: The keys to remove
     - returns: The number of registrations removed
     */
    @discardableResult func unregister<K: Keyed>(keys: Set<K>) -> Int {
        let keys = keys.map{ AnyKey($0)! }
        return lock.write {
            let count = registrations.count
            registrations = registrations.filter{ !keys.contains($0.key) }
            return count - registrations.count
        }
    }
    
}

public extension Resolving {
    
    /**
     Remove all registrations from Guise.
     
     - returns: The number of registrations removed
     */
    @discardableResult func clear() -> Int {
        return unregister(keys: keys)
    }
    
    /**
     Remove registrations by type
     
     - parameter type: The registered type
     - parameter name: The registered name or `nil` for any name
     - parameter container: The registered container or `nil`  for any container
     
     - returns: The number of registrations removed
     
     - warning: The `name` and `container` parameters are optional. In other contexts,
     an optional `name` or `container` implicitly references the default name or container,
     but in this case, it means _any_ name or container.
     */
    @discardableResult func unregister<T>(type: T.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) -> Int {
        return unregister(keys: filter(type: type, name: name, container: container))
    }
    
    /**
     Remove registrations irrespective of type
     
     - parameter name: The registered name or `nil` for any name
     - parameter container: The registered container or `nil`  for any container
     
     - returns: The number of registrations removed
     
     - warning: The `name` and `container` parameters are optional. In other contexts,
     an optional `name` or `container` implicitly references the default name or container,
     but in this case, it means _any_ name or container.
     */
    @discardableResult func unregister(name: AnyHashable? = nil, container: AnyHashable? = nil) -> Int {
        if name == nil && container == nil {
            return unregister(keys: keys)
        } else {
            return unregister(keys: filter(name: name, container: container))
        }
    }
}

// MARK: -

public extension Guise {
    /**
     Remove all registrations from Guise.
     
     - returns: The number of registrations removed
     */
    @discardableResult static func clear() -> Int {
        return defaultResolver.clear()
    }
    
    /**
     Remove registrations by key.
     
     - parameter keys: The keys to remove
     - returns: The number of registrations removed
     */
    @discardableResult static func unregister<K: Keyed>(keys: Set<K>) -> Int {
        return defaultResolver.unregister(keys: keys)
    }
    
    /**
     Remove registrations by type
     
     - parameter type: The registered type
     - parameter name: The registered name or `nil` for any name
     - parameter container: The registered container or `nil`  for any container
     
     - returns: The number of registrations removed
     
     - warning: The `name` and `container` parameters are optional. In other contexts,
     an optional `name` or `container` implicitly references the default name or container,
     but in this case, it means _any_ name or container.
     */
    @discardableResult static func unregister<T>(type: T.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) -> Int {
        return defaultResolver.unregister(type: type, name: name, container: container)
    }
    
    /**
     Remove registrations irrespective of type
     
     - parameter name: The registered name or `nil` for any name
     - parameter container: The registered container or `nil`  for any container
     
     - returns: The number of registrations removed
     
     - warning: The `name` and `container` parameters are optional. In other contexts,
     an optional `name` or `container` implicitly references the default name or container,
     but in this case, it means _any_ name or container.
     */
    @discardableResult static func unregister(name: AnyHashable? = nil, container: AnyHashable? = nil) -> Int {
        return defaultResolver.unregister(name: name, container: container)
    }
}
