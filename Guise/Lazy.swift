//
//  Lazy.swift
//  Guise
//
//  Created by Gregory Higley on 12/17/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public struct Lazy<RegisteredType> {
    
    public let cached: Bool?
    public let registration: Registration
    
    public init(_ registration: Registration, cached: Bool? = nil) {
        self.registration = registration
        self.cached = cached
    }
    
    public func resolve(parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        return registration.resolve(parameter: parameter, cached: cached ?? self.cached)
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
