//
//  Unregister.swift
//  Guise
//
//  Created by Gregory Higley on 12/12/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolving {
    
    /**
     Unregisters the registration made under `key`.
     
     - parameter key: The key whose registration should be removed
     - returns: `true` if the registration was removed, otherwise `false`
     */
    @discardableResult func unregister<K: Keyed>(key: K) -> Bool {
        return unregister(keys: [key]) == 1
    }
    
    /**
     Removes *all* registrations of the given `type` in `container`.
     
     ```
     Guise.unregister(type: Plugin.self, container: Container.plugins)
     ```
     
     - parameter type: The type of registrations to remove
     - parameter container: The container from which to remove the registrations
     
     - returns: The number of registrations removed
     */
    @discardableResult func unregister<RegisteredType>(type: RegisteredType.Type, container: AnyHashable = Guise.Container.default) -> Int {
        return unregister(keys: filter(type: type, container: container).keys)
    }
    
    /**
     Removes all registrations in `container`.
     
     - parameter container: The container from which to remove the registrations
     - returns: The number of registrations removed
     */
    @discardableResult func unregister(container: AnyHashable) -> Int {
        return unregister(keys: filter(container: container).keys)
    }
    
    /**
     Clears registrations and/or injections from Guise.
     
     - parameter clear: What to clear: either `.registrations` or `.injections` or `.both`
     - returns: A tuple indicating how many registrations and/or injections were cleared
     */
    @discardableResult func clear(_ clear: Guise.Clear = .both) -> (registrations: Int, injections: Int) {
        var cleared = (registrations: 0, injections: 0)
        if clear.contains(.registrations) {
            cleared.registrations = unregister(keys: keys)
        }
        if clear.contains(.injections) {
            cleared.injections = unregister(injectables: injectables)
        }
        return cleared
    }
    
}

public extension _Guise {
    
    /**
     Unregisters the registration made under `key`.
     
     - parameter key: The key whose registration should be removed
     - returns: `true` if the registration was removed, otherwise `false`
     */
    @discardableResult static func unregister<K: Keyed>(key: K) -> Bool {
        return resolver.unregister(key: key)
    }
    
    /**
     Removes *all* registrations of the given `type` in `container`.
     
     ```
     Guise.unregister(type: Plugin.self, container: Container.plugins)
     ```
     
     - parameter type: The type of registrations to remove
     - parameter container: The container from which to remove the registrations
     
     - returns: The number of registrations removed
     */
    @discardableResult static func unregister<RegisteredType>(type: RegisteredType.Type, container: AnyHashable = Guise.Container.default) -> Int {
        return resolver.unregister(type: type, container: container)
    }
    
    /**
     Removes all registrations in `container`.
     
     - parameter container: The container from which to remove the registrations
     - returns: The number of registrations removed
     */
    @discardableResult static func unregister(container: AnyHashable) -> Int {
        return resolver.unregister(container: container)
    }
    
    /**
     Clears registrations and/or injections from Guise.
     
     - parameter clear: What to clear: either `.registrations` or `.injections` or `.both`
     - returns: A tuple indicating how many registrations and/or injections were cleared
     */
    @discardableResult static func clear(_ clear: Guise.Clear = .both) -> (registrations: Int, injections: Int) {
        return resolver.clear(clear)
    }
    
}
