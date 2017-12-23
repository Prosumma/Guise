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
    public let metadata: Any
    private var _value: Value
    private weak var _resolver: Resolving?
    
    public init(_ registration: Registration, resolver: Resolving, cached: Bool? = nil) {
        self._value = .unresolved(registration)
        self.metadata = registration.metadata
        self.cached = cached
        // Let's not have more weakrefs than we need.
        if registration.expectsResolver {
            self._resolver = resolver
        }
    }
    
    public init(value: RegisteredType?, key: Key<RegisteredType> = Key<RegisteredType>(), metadata: Any = ()) {
        self.cached = nil
        self._value = .resolved(value)
        self.metadata = metadata
    }
    
    public var value: RegisteredType? {
        return resolve()
    }
    
    public var resolved: Bool {
        switch _value {
        case .resolved: return true
        case .unresolved: return false
        }
    }
    
    public func resolve(parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        switch _value {
        case .resolved(let resolved):
            return resolved
        case .unresolved(let registration):
            let parameter = registration.expectsResolver && !(parameter is Resolving) ? _resolver! : parameter
            let resolved: RegisteredType? = registration.resolve(parameter: parameter, cached: cached ?? self.cached)
            _value = .resolved(resolved)
            return resolved
        }
    }
}

extension Resolving {
    
    public func lazy<RegisteredType>(key: Key<RegisteredType>, cached: Bool? = nil) -> Lazy<RegisteredType>? {
        guard let registration = filter(key: key) else { return nil }
        return Lazy(registration, resolver: self, cached: cached)
    }
    
    public func lazy<RegisteredType, Keys: Sequence>(keys: Keys, cached: Bool? = nil) -> [Lazy<RegisteredType>] where Keys.Element == Key<RegisteredType> {
        let registrations: [Key<RegisteredType>: Registration] = filter(keys: keys)
        return registrations.map{ Lazy($0.value, resolver: self, cached: cached) }
    }
    
    public func lazy<RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Lazy<RegisteredType>? {
        let key = Key<RegisteredType>(name: name, container: container)
        return lazy(key: key, cached: cached)
    }
    
}

extension _Resolving {

    public static func lazy<RegisteredType>(key: Key<RegisteredType>, cached: Bool? = nil) -> Lazy<RegisteredType>? {
        return resolver.lazy(key: key, cached: cached)
    }
    
    public static func lazy<RegisteredType, Keys: Sequence>(keys: Keys, cached: Bool? = nil) -> [Lazy<RegisteredType>] where Keys.Element == Key<RegisteredType> {
        return resolver.lazy(keys: keys, cached: cached)
    }
    
    public static func lazy<RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Lazy<RegisteredType>? {
        return resolver.lazy(type: type, name: name, container: container, cached: cached)
    }
    
}
