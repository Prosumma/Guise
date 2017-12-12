//
//  Registering.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Guising {
    
    func register<Parameter, RegisteredType>(key: Key<RegisteredType>, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<Parameter, RegisteredType>) -> Key<RegisteredType> {
        return register(key: key, metadata: metadata, cached: cached, resolution: resolution)
    }
    
    func register<Parameter, RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<Parameter, RegisteredType>) -> Key<RegisteredType> {
        return register(key: Key<RegisteredType>(name: name, container: container), metadata: metadata, cached: cached, resolution: resolution)
    }
    
    func register<RegisteredType>(factory: @escaping @autoclosure () -> RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<RegisteredType> {
        return register(key: Key<RegisteredType>(name: name, container: container), metadata: metadata, cached: true, resolution: factory)
    }
    
}

public extension _Guise {

    static func register<Parameter, RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<Parameter, RegisteredType>) -> Key<RegisteredType> {
        return register(key: Key<RegisteredType>(name: name, container: container), metadata: metadata, cached: cached, resolution: resolution)
    }
    
    static func register<RegisteredType>(factory: @escaping @autoclosure () -> RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<RegisteredType> {
        return register(key: Key<RegisteredType>(name: name, container: container), metadata: metadata, cached: true, resolution: factory)
    }
    
}
