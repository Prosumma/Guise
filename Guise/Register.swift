//
//  Register.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolving {
    
    @discardableResult func register<ParameterType, HoldingType: Holder>(key: Key<HoldingType.Held>, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<ParameterType, HoldingType>) -> Key<HoldingType.Held> {
        return register(key: key, metadata: metadata, cached: cached, resolution: resolution)
    }
    
    @discardableResult func register<ParameterType, RegisteredType>(key: Key<RegisteredType>, metadata: Any = (), cached: Bool = false, resolution: @escaping (ParameterType) -> RegisteredType) -> Key<RegisteredType> {
        return register(key: key, metadata: metadata, cached: cached) { Strong(resolution($0)) }
    }
    
    @discardableResult func register<HoldingType: Holder>(holder: @escaping @autoclosure () -> HoldingType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = (), cached: Bool = false) -> Key<HoldingType.Held> {
        let key = Key<HoldingType.Held>(name: name, container: container)
        return register(key: key, metadata: metadata, cached: cached, resolution: holder)
    }
    
    @discardableResult func register<ParameterType, RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<ParameterType, RegisteredType>) -> Key<RegisteredType> {
        return register(key: Key<RegisteredType>(name: name, container: container), metadata: metadata, cached: cached, resolution: resolution)
    }
    
    @discardableResult func register<ParameterType, HoldingType: Holder>(type: HoldingType.Held.Type = HoldingType.Held.self, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<ParameterType, HoldingType>) -> Key<HoldingType.Held> {
        let key = Key<HoldingType.Held>(name: name, container: container)
        return register(key: key, metadata: metadata, cached: cached, resolution: resolution)
    }
    
    @discardableResult func register<RegisteredType>(factory: @escaping @autoclosure () -> RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<RegisteredType> {
        return register(holder: Uncached(factory()), name: name, container: container, metadata: metadata, cached: false)
    }

    @discardableResult func register<RegisteredType>(instance: @escaping @autoclosure () -> RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<RegisteredType> {
        return register(holder: Cached(instance()), name: name, container: container, metadata: metadata, cached: true)
    }
    
    @discardableResult func register<RegisteredType>(weak instance: RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<RegisteredType> {
        // This must be done in two steps, otherwise the block will capture the instance parameter and it will
        // not be weakly held.
        let weakling = Weak(instance)
        return register(holder: weakling, name: name, container: container, metadata: metadata)
    }
    
    func into<Target>(injectable type: Target.Type) -> Injector<Target> {
        return Injector(resolver: self)
    }
    
}

public extension _Resolving {
    
    @discardableResult static func register<ParameterType, HoldingType: Holder>(key: Key<HoldingType.Held>, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<ParameterType, HoldingType>) -> Key<HoldingType.Held> {
        return resolver.register(key: key, metadata: metadata, cached: cached, resolution: resolution)
    }
    
    @discardableResult static func register<ParameterType, RegisteredType>(key: Key<RegisteredType>, metadata: Any = (), cached: Bool = false, resolution: @escaping (ParameterType) -> RegisteredType) -> Key<RegisteredType> {
        return resolver.register(key: key, metadata: metadata, cached: cached, resolution: resolution)
    }
    
    @discardableResult static func register<HoldingType: Holder>(holder: @escaping @autoclosure () -> HoldingType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = (), cached: Bool = false) -> Key<HoldingType.Held> {
        return resolver.register(holder: holder, name: name, container: container, metadata: metadata, cached: cached)
    }
    
    @discardableResult static func register<Parameter, RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<Parameter, RegisteredType>) -> Key<RegisteredType> {
        return resolver.register(type: type, name: name, container: container, metadata: metadata, cached: cached, resolution: resolution)
    }
    
    @discardableResult static func register<ParameterType, HoldingType: Holder>(type: HoldingType.Held.Type = HoldingType.Held.self, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<ParameterType, HoldingType>) -> Key<HoldingType.Held> {
        return resolver.register(type: type, name: name, container: container, metadata: metadata, cached: cached, resolution: resolution)
    }
    
    @discardableResult static func register<RegisteredType>(factory: @escaping @autoclosure () -> RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<RegisteredType> {
        return resolver.register(factory: factory, name: name, container: container, metadata: metadata)
    }
    
    @discardableResult static func register<RegisteredType>(instance: @escaping @autoclosure () -> RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<RegisteredType> {
        return resolver.register(instance: instance, name: name, container: container, metadata: metadata)
    }
    
    @discardableResult static func register<RegisteredType>(weak instance: RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<RegisteredType> {
        return resolver.register(weak: instance, name: name, container: container, metadata: metadata)
    }
    
    static func into<Target>(injectable type: Target.Type) -> Injector<Target> {
        return resolver.into(injectable: type)
    }
}
