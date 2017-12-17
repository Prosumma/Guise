//
//  Lazy.swift
//  Guise
//
//  Created by Gregory Higley on 12/17/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public final class Lazy<RegisteredType> {
    private indirect enum Value {
        case resolved(RegisteredType?)
        case unresolved(Registration)
    }
    
    public let cached: Bool?
    private var value: Value
    
    public init(_ registration: Registration, cached: Bool? = nil) {
        self.value = .unresolved(registration)
        self.cached = cached
    }
    
    public init(value: RegisteredType?) {
        self.cached = nil
        self.value = .resolved(value)
    }
    
    public func resolve(parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        switch value {
        case .resolved(let resolved):
            return resolved
        case .unresolved(let registration):
            let resolved: RegisteredType? = registration.resolve(parameter: parameter, cached: cached ?? self.cached)
            value = .resolved(resolved)
            return resolved
        }
    }
}

extension Guising {
    
    public func lazy<RegisteredType>(key: Key<RegisteredType>, cached: Bool? = nil) -> Lazy<RegisteredType>? {
        guard let registration = filter(key: key) else { return nil }
        return Lazy(registration, cached: cached)
    }
    
    public func lazy<RegisteredType, Keys: Sequence>(keys: Keys, cached: Bool? = nil) -> [Lazy<RegisteredType>] where Keys.Element == Key<RegisteredType> {
        let registrations: [Key<RegisteredType>: Registration] = filter(keys: keys)
        return registrations.map{ Lazy($0.value, cached: cached) }
    }
    
    public func lazy<RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Lazy<RegisteredType>? {
        let key = Key<RegisteredType>(name: name, container: container)
        return lazy(key: key, cached: cached)
    }
    
}

extension _Guise {

    public static func lazy<RegisteredType>(key: Key<RegisteredType>, cached: Bool? = nil) -> Lazy<RegisteredType>? {
        return defaultResolver.lazy(key: key, cached: cached)
    }
    
    public static func lazy<RegisteredType, Keys: Sequence>(keys: Keys, cached: Bool? = nil) -> [Lazy<RegisteredType>] where Keys.Element == Key<RegisteredType> {
        return defaultResolver.lazy(keys: keys, cached: cached)
    }
    
    public static func lazy<RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Lazy<RegisteredType>? {
        return defaultResolver.lazy(type: type, name: name, container: container, cached: cached)
    }
    
}
