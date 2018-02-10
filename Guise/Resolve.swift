//
//  Resolve.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolving {
    
    func resolve<RegisteredType>(key: Key<RegisteredType>, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        guard let registration = filter(key: key) else { return nil }
        let parameter = registration.expectsResolver && !(parameter is Resolving) ? self : parameter
        return registration.resolve(parameter: parameter, cached: cached)
    }
    
    public func resolve<RegisteredType, Keys: Sequence>(keys: Keys, parameter: Any = (), cached: Bool? = nil) -> [RegisteredType] where Keys.Element == Key<RegisteredType> {
        let registrations: [Key<RegisteredType>: Registration] = filter(keys: keys)
        return registrations.flatMap{ $0.value.resolve(parameter: parameter, cached: cached) }
    }
    
    func resolve<RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable  = Guise.Container.default, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        return resolve(key: Key<RegisteredType>(name: name, container: container), parameter: parameter, cached: cached)
    }
    
    @discardableResult func resolve<Target>(into instance: Target) -> Target {
        let injector = self as! Injecting
        return injector.inject?(instance, self) as! Target? ?? instance
    }
}

public extension _Resolving {

    static func resolve<RegisteredType>(key: Key<RegisteredType>, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        return resolver.resolve(key: key, parameter: parameter, cached: cached)
    }
    
    static func resolve<RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable  = Guise.Container.default, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        return resolver.resolve(type: type, name: name, container: container, parameter: parameter, cached: cached)
    }
    
    @discardableResult static func resolve<Target>(into instance: Target) -> Target {
        return resolver.resolve(into: instance)
    }
}
