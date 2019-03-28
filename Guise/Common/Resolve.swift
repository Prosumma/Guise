//
//  Resolve.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolving {
    
    /**
     Resolves the registration made with the given `key`.
     
     If the original registration required a parameter, it must be passed here. The value
     of `cached` may be used to override the caching behavior with which the registration was
     made _if it can be overridden_. If the `register` overload used to create the registration
     included a `cached` parameter, then caching can be overridden here. If not, then it cannot.
     (So, for example, a registration made with `register(instance:)` cannot have its caching
     semantics overridden. But a registration made with `register(strong:)` can.)
     
     - parameter key: The key whose registration should be resolved
     - parameter parameter: The parameter to pass to the registration block
     - parameter cached: Desired caching semantics
     
     - returns: An instance of `RegisteredType`, or `nil` if it could not be resolved
     */
    func resolve<RegisteredType>(key: Key<RegisteredType>, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        guard let registration = filter(key: key) else { return nil }
        let parameter = registration.expectsResolver && parameter is Void ? self : parameter
        return registration.resolve(parameter: parameter, cached: cached)
    }
    
    /**
     Resolves the registrations made with the given keys.
     
     This method can be useful for resolving many analogous registrations, all of the same type and
     taking the same parameter (if any).
     
     ```
     let key1 = Key<Plugin>(name: Plugin.x)
     let key2 = Key<Plugin>(name: Plugin.y)
     let plugins = Guise.resolve(keys: [key1, key2], parameter: 54321, cached: true)
     ```
     
     The code above resolves two registrations. If either or both registrations is not found, the resulting array
     simply excludes them.
     
     The value of `cached` may be used to override the caching behavior with which the registration was
     made _if it can be overridden_. If the `register` overload used to create the registration
     included a `cached` parameter, then caching can be overridden here. If not, then it cannot.
     (So, for example, a registration made with `register(instance:)` cannot have its caching
     semantics overridden. But a registration made with `register(strong:)` can.
     
     - parameter keys: The keys whose registrations should be resolved
     - parameter parameter: The parameter to pass to the registration blocks
     - parameter cached: Desired caching semantics
     
     - returns: An array of instances of the registered type
     */
    func resolve<RegisteredType, Keys: Sequence>(keys: Keys, parameter: Any = (), cached: Bool? = nil) -> [RegisteredType] where Keys.Element == Key<RegisteredType> {
        let registrations: [Key<RegisteredType>: Registration] = filter(keys: keys)
        return registrations.compactMap {
            let parameter = $0.value.expectsResolver && parameter is Void ? self : parameter
            return $0.value.resolve(parameter: parameter, cached: cached)
        }
    }
    
    /**
     Resolves a registration.
     
     This is by far the most commonly used overload. In its simplest form, no parameters are needed
     and the defaults will suffice:
     
     ```
     let foo: Foo = Guise.resolve()!
     ```
     
     The resolver knows which type to resolve via type inference.
     
     The value of `cached` may be used to override the caching behavior with which the registration was
     made _if it can be overridden_. If the `register` overload used to create the registration
     included a `cached` parameter, then caching can be overridden here. If not, then it cannot.
     (So, for example, a registration made with `register(instance:)` cannot have its caching
     semantics overridden. But a registration made with `register(strong:)` can.
     
     - parameter type: The registered type to resolve
     - parameter name: The name under which the registration was made
     - parameter container: The container in which the registration was made
     - parameter parameter: The parameter to pass to the resolution block
     - parameter cached: The desired caching semantics
     
     - returns: An instance of the registered type or `nil` if it could not be resolved
     */
    func resolve<RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable  = Guise.Container.default, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        return resolve(key: Key<RegisteredType>(name: name, container: container), parameter: parameter, cached: cached)
    }
}

public extension _Guise {

    /**
     Resolves the registration made with the given `key`.
     
     If the original registration required a parameter, it must be passed here. The value
     of `cached` may be used to override the caching behavior with which the registration was
     made _if it can be overridden_. If the `register` overload used to create the registration
     included a `cached` parameter, then caching can be overridden here. If not, then it cannot.
     (So, for example, a registration made with `register(instance:)` cannot have its caching
     semantics overridden. But a registration made with `register(strong:)` can.)
     
     - parameter key: The key whose registration should be resolved
     - parameter parameter: The parameter to pass to the registration block
     - parameter cached: Desired caching semantics
     
     - returns: An instance of `RegisteredType`, or `nil` if it could not be resolved
     */
    static func resolve<RegisteredType>(key: Key<RegisteredType>, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        return resolver.resolve(key: key, parameter: parameter, cached: cached)
    }
    
    /**
     Resolves the registrations made with the given keys.
     
     This method can be useful for resolving many analogous registrations, all of the same type and
     taking the same parameter (if any).
     
     ```
     let key1 = Key<Plugin>(name: Plugin.x)
     let key2 = Key<Plugin>(name: Plugin.y)
     let plugins = Guise.resolve(keys: [key1, key2], parameter: 54321, cached: true)
     ```
     
     The code above resolves two registrations. If either or both registrations is not found, the resulting array
     simply excludes them.
     
     The value of `cached` may be used to override the caching behavior with which the registration was
     made _if it can be overridden_. If the `register` overload used to create the registration
     included a `cached` parameter, then caching can be overridden here. If not, then it cannot.
     (So, for example, a registration made with `register(instance:)` cannot have its caching
     semantics overridden. But a registration made with `register(strong:)` can.
     
     - parameter keys: The keys whose registrations should be resolved
     - parameter parameter: The parameter to pass to the registration blocks
     - parameter cached: Desired caching semantics
     
     - returns: An array of instances of the registered type
     */
    static func resolve<RegisteredType, Keys: Sequence>(keys: Keys, parameter: Any = (), cached: Bool? = nil) -> [RegisteredType] where Keys.Element == Key<RegisteredType> {
        return resolver.resolve(keys: keys, parameter: parameter, cached: cached)
    }
    
    /**
     Resolves a registration.
     
     This is by far the most commonly used overload. In its simplest form, no parameters are needed
     and the defaults will suffice:
     
     ```
     let foo: Foo = Guise.resolve()!
     ```
     
     The resolver knows which type to resolve via type inference.
     
     The value of `cached` may be used to override the caching behavior with which the registration was
     made _if it can be overridden_. If the `register` overload used to create the registration
     included a `cached` parameter, then caching can be overridden here. If not, then it cannot.
     (So, for example, a registration made with `register(instance:)` cannot have its caching
     semantics overridden. But a registration made with `register(strong:)` can.
     
     - parameter type: The registered type to resolve
     - parameter name: The name under which the registration was made
     - parameter container: The container in which the registration was made
     - parameter parameter: The parameter to pass to the resolution block
     - parameter cached: The desired caching semantics
     
     - returns: An instance of the registered type or `nil` if it could not be resolved
     */
    static func resolve<RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable  = Guise.Container.default, parameter: Any = (), cached: Bool? = nil) -> RegisteredType? {
        return resolver.resolve(type: type, name: name, container: container, parameter: parameter, cached: cached)
    }
}
