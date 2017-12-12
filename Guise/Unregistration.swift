//
//  Unregistration.swift
//  Guise
//
//  Created by Gregory Higley on 12/12/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Guising {
    
    @discardableResult func clear() -> Int {
        return unregister(keys: keys)
    }
    
}

public extension _Guise {
    
    @discardableResult static func clear() -> Int {
        return defaultResolver.clear()
    }
    
}
