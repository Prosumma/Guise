//
//  Unregister.swift
//  Guise
//
//  Created by Gregory Higley on 9/3/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

extension Guise {
    
    /**
     Remove all registrations from Guise.
     
     - returns: The number of registrations removed
     */
    @discardableResult public static func clear() -> Int {
        return lock.write {
            let count = registrations.count
            registrations = [:]
            return count
        }
    }
    
    /**
     Remove registrations by key.
     
     - parameter keys: The keys to remove
     - returns: The number of registrations removed
     */
    @discardableResult  public static func unregister<K: Keyed>(keys: Set<K>) -> Int {
        let keys = keys.map{ AnyKey($0)! }
        return lock.write {
            let count = registrations.count
            registrations = registrations.filter{ !keys.contains($0.key) }
            return count - registrations.count
        }
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
    @discardableResult  public static func unregister<T>(type: T.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) -> Int {
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
    @discardableResult public static func unregister(name: AnyHashable? = nil, container: AnyHashable? = nil) -> Int {
        if name == nil && container == nil {
            return clear()
        } else {
            return unregister(keys: filter(name: name, container: container))
        }
    }
    
}
