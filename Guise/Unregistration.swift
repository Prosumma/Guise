//
//  Unregistration.swift
//  Guise
//
//  Created by Gregory Higley on 12/12/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Guising {
    
    @discardableResult func unregister<K: Keyed>(key: K) -> Int {
        return unregister(keys: [key])
    }
    
    @discardableResult func unregister<RegisteredType>(type: RegisteredType.Type, container: AnyHashable = Guise.Container.default) -> Int {
        return unregister(keys: filter(type: type, container: container).keys)
    }
    
    @discardableResult func unregister(container: AnyHashable) -> Int {
        return unregister(keys: filter(container: container).keys)
    }
    
    @discardableResult func clear() -> Int {
        return unregister(keys: keys)
    }
    
}

public extension _Guise {
    
    @discardableResult static func unregister<K: Keyed>(key: K) -> Int {
        return defaultResolver.unregister(key: key)
    }
    
    @discardableResult static func unregister<RegisteredType>(type: RegisteredType.Type, container: AnyHashable = Guise.Container.default) -> Int {
        return defaultResolver.unregister(type: type, container: container)
    }
    
    @discardableResult static func unregister(container: AnyHashable) -> Int {
        return defaultResolver.unregister(container: container)
    }
    
    @discardableResult static func clear() -> Int {
        return defaultResolver.clear()
    }
    
}
