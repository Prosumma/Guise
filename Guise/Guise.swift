//
//  Guise.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public struct Guise: _Resolving {
    public enum Name {
        case `default`
    }
    
    public enum Container {
        case `default`
    }
    
    public static var resolver: Resolving = Resolver()
    
    @discardableResult public static func register<ParameterType, HoldingType: Holder>(key: Key<HoldingType.Held>, metadata: Any, cached: Bool, resolution: @escaping Resolution<ParameterType, HoldingType>) -> Key<HoldingType.Held> {
        return resolver.register(key: key, metadata: metadata, cached:cached, resolution: resolution)
    }

    @discardableResult public static func unregister<Keys: Sequence>(keys: Keys) -> Int where Keys.Element: Keyed {
        return resolver.unregister(keys: keys)
    }

    public static func filter<K: Keyed>(_ filter: @escaping (K) -> Bool) -> [K: Registration] {
        return resolver.filter(filter)
    }
    
    public static var injectables: Set<String> {
        return resolver.injectables
    }
    
    public static func register(key: String, injection: @escaping Injection<Any>) -> String {
        return resolver.register(key: key, injection: injection)
    }
    
    public static func resolve<Target>(into target: Target) -> Target {
        return resolver.resolve(into: target)
    }
    
    public static func unregister<Keys: Sequence>(keys: Keys) -> Int where Keys.Element == String {
        return resolver.unregister(keys: keys)
    }
}
