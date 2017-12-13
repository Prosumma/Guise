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
    
    @discardableResult func clear() -> Int {
        return unregister(keys: keys)
    }
    
}

public extension _Guise {
    
    @discardableResult static func unregister<K: Keyed>(key: K) -> Int {
        return defaultResolver.unregister(key: key)
    }
    
    @discardableResult static func clear() -> Int {
        return defaultResolver.clear()
    }
    
}
