//
//  Guise.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public struct Guise: _Guise {
    public enum Name {
        case `default`
    }
    
    public enum Container {
        case `default`
        case injections
    }
    
    public static var defaultResolver: Guising = Resolver()
    
    public static func register<Parameter, RegisteredType>(key: Key<RegisteredType>, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<Parameter, RegisteredType>) -> Key<RegisteredType> {
        return defaultResolver.register(key: key, metadata: metadata, cached: cached, resolution: resolution)
    }
    
    public static func unregister<K: Keyed>(keys: Set<K>) -> Int {
        return defaultResolver.unregister(keys: keys)
    }
    
    public static func filter<K: Keyed>(key: K.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) -> [K: Registration] {
        return defaultResolver.filter(key: key, name: name, container: container)
    }
}
