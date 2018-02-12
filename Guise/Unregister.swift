//
//  Unregister.swift
//  Guise
//
//  Created by Gregory Higley on 12/12/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolving {
    
    @discardableResult func unregister<K: Keyed>(key: K) -> Int {
        return unregister(keys: [key])
    }
    
    @discardableResult func unregister<RegisteredType>(type: RegisteredType.Type, container: AnyHashable = Guise.Container.default) -> Int {
        return unregister(keys: filter(type: type, container: container).keys)
    }
    
    @discardableResult func unregister(container: AnyHashable) -> Int {
        return unregister(keys: filter(container: container).keys)
    }
    
    @discardableResult func clear(_ clear: Guise.Clear = .all) -> Int {
        var cleared = 0
        if clear.contains(.registrations) {
            cleared = unregister(keys: keys)
        }
        if clear.contains(.injections) {
            cleared += unregister(keys: injectables)
        }
        return cleared
    }
    
}

public extension _Guise {
    
    @discardableResult static func unregister<K: Keyed>(key: K) -> Int {
        return resolver.unregister(key: key)
    }
    
    @discardableResult static func unregister<RegisteredType>(type: RegisteredType.Type, container: AnyHashable = Guise.Container.default) -> Int {
        return resolver.unregister(type: type, container: container)
    }
    
    @discardableResult static func unregister(container: AnyHashable) -> Int {
        return resolver.unregister(container: container)
    }
    
    @discardableResult static func clear(_ clear: Guise.Clear = .all) -> Int {
        return resolver.clear(clear)
    }
    
}
