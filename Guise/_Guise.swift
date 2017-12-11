//
//  _Guise.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public protocol _Guise {
    static var defaultResolver: Guising { get set }
    static func register<Parameter, RegisteredType>(key: Key<RegisteredType>, metadata: Any, cached: Bool, resolution: Resolution<Parameter, RegisteredType>) -> Key<RegisteredType>
    static func unregister<Keys: Sequence>(keys: Keys) -> Int where Keys.Element: Keyed
    static func filter<K: Keyed>(key: K.Type, name: AnyHashable?, container: AnyHashable?) -> [K: Registration]
}

public extension Guising {
    
    static func register<Parameter, RegisteredType>(key: Key<RegisteredType>, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<Parameter, RegisteredType>) -> Key<RegisteredType> {
        return register(key: key, metadata: metadata, cached: cached, resolution: resolution)
    }
    
    static func filter<K: Keyed>(key: K.Type = K.self, name: AnyHashable? = nil, container: AnyHashable? = nil) -> [K: Registration] {
        return filter(key: key, name: name, container: container)
    }
    
}

