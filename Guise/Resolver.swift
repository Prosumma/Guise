//
//  Resolver.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public final class Resolver: Resolving {

    internal var lock = Lock()
    
    // MARK: Registrations
    
    internal var registrations = [AnyKey: Registration]()
    
    public var keys: Set<AnyKey> {
        return Set(lock.read{ registrations.keys })
    }
    
    public func filter<K: Keyed & Hashable>(key: K) -> Registration? {
        let key = AnyKey(key)!
        return lock.read{ registrations[key] }
    }
    
    @discardableResult public func register<RegisteredType, ParameterType, HoldingType: Holder>(key: Key<RegisteredType>, metadata: Any, cached: Bool, resolution: @escaping Resolution<ParameterType, HoldingType>) -> Key<RegisteredType> where HoldingType.Held == RegisteredType {
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
    
    // MARK: Injecting
    
    internal var injections = [String: Injection<Any>]()
    
    public var injectables: Set<String> {
        return Set(lock.read{ injections.keys })
    }
    
    public func register(injectable: String, injection: @escaping Injection<Any>) -> String {
        lock.write { injections[injectable] = injection }
        return injectable
    }
    
    public func resolve<Target>(into target: Target) -> Target {
        let injections = lock.read{ self.injections.values }
        var target = target
        for injection in injections {
            target = injection(target, self) as! Target
        }
        return target
    }
    
    public func unregister<Keys: Sequence>(keys: Keys) -> Int where Keys.Element == String {
        return lock.write {
            let count = injections.count
            injections = injections.filter{ !keys.contains($0.key) }
            return count - injections.count
        }
    }
    
}

