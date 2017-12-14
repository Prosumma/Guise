//
//  Resolver.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public class Resolver: Guising {
    
    internal var lock = Lock()
    internal var registrations = [AnyKey: Registration]()
    
    // MARK: Guising
    
    @discardableResult public func register<RegisteredType, ParameterType, ResolvedType>(key: Key<RegisteredType>, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<ParameterType, ResolvedType>) -> Key<RegisteredType> {
        lock.write { registrations[AnyKey(key)!] = _Registration(metadata: metadata, cached: cached, resolution: resolution) }
        return key
    }
    
    @discardableResult public func unregister<Keys: Sequence>(keys: Keys) -> Int where Keys.Element: Keyed {
        return lock.write {
            let count = registrations.count
            registrations = registrations.filter{ element in !keys.contains{ $0 == element.key } }
            return count - registrations.count
        }
    }

    public func filter<K: Keyed>(_ filter: @escaping (K) -> Bool) -> [K: Registration] {
        return lock.read {
            var result = [K: Registration]()
            for element in registrations {
                guard let key = K(element.key), filter(key) else { continue }
                result[key] = element.value
            }
            return result
        }
    }
    
    // MARK: Optimizations
    
    public var keys: Set<AnyKey> {
        return Set(lock.read{ registrations.keys })
    }
    
    public func filter<K: Keyed & Hashable>(key: K) -> Registration? {
        let key = AnyKey(key)!
        return lock.read{ registrations[key] }
    }
    
}

