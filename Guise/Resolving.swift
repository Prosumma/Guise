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
        return registration.resolve(parameter: parameter, cached: cached)
    }
    
    func resolve<RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable  = Guise.Container.default, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        return resolve(key: Key<RegisteredType>(name: name, container: container), parameter: parameter, cached: cached)
    }
    
}

public extension _Guise {

    static func resolve<RegisteredType>(key: Key<RegisteredType>, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        guard let registration = filter(key: key) else { return nil }
        return registration.resolve(parameter: parameter, cached: cached)
    }
    
    static func resolve<RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable  = Guise.Container.default, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        return resolve(key: Key<RegisteredType>(name: name, container: container), parameter: parameter, cached: cached)
    }
    
}
