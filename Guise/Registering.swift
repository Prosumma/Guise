//
//  Registering.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Guising {
    
    @discardableResult func register<Parameter, RegisteredType>(key: Key<RegisteredType>, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<Parameter, RegisteredType>) -> Key<RegisteredType> {
        return register(key: key, metadata: metadata, cached: cached, resolution: resolution)
    }
    
    @discardableResult func register<Parameter, RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<Parameter, RegisteredType>) -> Key<RegisteredType> {
        return register(key: Key<RegisteredType>(name: name, container: container), metadata: metadata, cached: cached, resolution: resolution)
    }
    
    @discardableResult func register<RegisteredType>(factory: @escaping @autoclosure () -> RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<RegisteredType> {
        return register(key: Key<RegisteredType>(name: name, container: container), metadata: metadata, cached: false, resolution: factory)
    }

    @discardableResult func register<RegisteredType>(instance: @escaping @autoclosure () -> RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<RegisteredType> {
        return register(key: Key<RegisteredType>(name: name, container: container), metadata: metadata, cached: true, resolution: instance)
    }
    
    @discardableResult func register<RegisteredType>(weak instance: RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<Weak<RegisteredType>> {
        let weakling = Weak(instance)
        return register(instance: weakling, name: name, container: container, metadata: metadata)
    }
    
    @discardableResult func register<Target>(injectable: Target.Type, injection: @escaping Injection<Target>) -> Key<Target> {
        let key = Key<Target>(container: Guise.Container.injections)
        return register(key: key, metadata: (), cached: false) { (parameters: InjectionParameters) in
            return injection(parameters.target, parameters.resolver)
        }
    }
    
    func register<Target>(injectable: Target.Type) -> Injector<Target> {
        return Injector(resolver: self)
    }
}

public extension _Guise {
    
    @discardableResult static func register<Parameter, RegisteredType>(key: Key<RegisteredType>, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<Parameter, RegisteredType>) -> Key<RegisteredType> {
        return defaultResolver.register(key: key, metadata: metadata, cached: cached, resolution: resolution)
    }

    @discardableResult static func register<Parameter, RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<Parameter, RegisteredType>) -> Key<RegisteredType> {
        return defaultResolver.register(type: type, name: name, container: container, metadata: metadata, cached: cached, resolution: resolution)
    }
    
    @discardableResult static func register<RegisteredType>(factory: @escaping @autoclosure () -> RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<RegisteredType> {
        return defaultResolver.register(factory: factory, name: name, container: container, metadata: metadata)
    }
    
    @discardableResult static func register<RegisteredType>(instance: @escaping @autoclosure () -> RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<RegisteredType> {
        return defaultResolver.register(instance: instance, name: name, container: container, metadata: metadata)
    }
    
    @discardableResult static func register<RegisteredType>(weak instance: RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<Weak<RegisteredType>> {
        return defaultResolver.register(weak: instance, name: name, container: container, metadata: metadata)
    }
    
    @discardableResult static func register<Target>(injectable: Target.Type, injection: @escaping Injection<Target>) -> Key<Target> {
        return defaultResolver.register(injectable: injectable, injection: injection)
    }
    
    static func register<Target>(injectable: Target.Type) -> Injector<Target> {
        return defaultResolver.register(injectable: injectable)
    }
}
