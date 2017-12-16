//
//  Resolving.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Guising {
    
    func resolve<RegisteredType>(key: Key<RegisteredType>, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        guard let registration = filter(key: key) else { return nil }
        let parameter = registration.expectsResolver && !(parameter is Guising) ? self : parameter
        return registration.resolve(parameter: parameter, cached: cached)
    }
    
    func resolve<RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable  = Guise.Container.default, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        return resolve(key: Key<RegisteredType>(name: name, container: container), parameter: parameter, cached: cached)
    }
    
    @discardableResult func resolve<Target>(into instance: Target) -> Target {
        let key = Key<Target>(container: Guise.Container.injections)
        guard let registration = filter(key: key) else { return instance }
        let parameter = InjectionParameters(target: instance, resolver: self)
        return registration.resolve(parameter: parameter, cached: false) ?? instance
    }
}

public extension _Guise {

    static func resolve<RegisteredType>(key: Key<RegisteredType>, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        return defaultResolver.resolve(key: key, parameter: parameter, cached: cached)
    }
    
    static func resolve<RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable  = Guise.Container.default, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        return defaultResolver.resolve(type: type, name: name, container: container, parameter: parameter, cached: cached)
    }
    
    @discardableResult static func resolve<Target>(into instance: Target) -> Target {
        return defaultResolver.resolve(into: instance)
    }
}
