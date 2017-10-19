//
//  Resolve.swift
//  Guise
//
//  Created by Gregory Higley on 9/3/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

extension Guise {
    
    /**
     Locate and resolve a registration.
     
     The first three parameters, `type`, `name`, and `container`, are used to construct a unique
     key through which to locate the registration. If it is not found, `nil` is returned. If it is
     found, it is resolved using the values of `parameter` and `cached`.
     
     By default, `cached` is `nil`, which means that the registered value of `cached` is used. If
     `cached` is `false` but the original registered value is `true`, the cached value is skipped
     and a new instance of `T` is created. If `cached` is `true` but the registered value of `cached`
     is `false`, a cached instance will be created for use whenever `resolve` is called with `cached` == `true`.
     
     All of the parameters of this method are optional. In the simplest case, `resolve` may be called like so:
     
     ```swift
     // Resolve the `Plugin` registered with
     // the default name and in the default container.
     let resolved = Guise.resolve()! as Plugin
     ```
     
     - parameter type: The type held by the registration and returned by `resolve`
     - parameter name: The name of the registration
     - parameter container: The container of the registration
     - parameter parameter: The parameter to pass to the registered resolution block when resolving
     - parameter cached: The desired caching behavior, as discussed above
     
     - returns: The resolved registration or `nil` if it was not found.
     */
    public static func resolve<T>(type: T.Type = T.self, name: AnyHashable = Name.default, container: AnyHashable = Container.default, parameter: Any = (), cached: Bool? = nil) -> T? {
        let key = AnyKey(type: T.self, name: name, container: container)
        guard let registration = lock.read({ registrations[key] }) else { return nil }
        return registration.resolve(parameter: parameter, cached: cached)
    }
    
    /**
     Locate and resolve a registration.
     
     If `key` is not registered, `nil` is returned.
     
     By default, `cached` is `nil`, which means that the registered value of `cached` is used. If
     `cached` is `false` but the original registered value is `true`, the cached value is skipped
     and a new instance of `T` is created. If `cached` is `true` but the registered value of `cached`
     is `false`, a cached instance will be created for use whenever `resolve` is called with `cached` == `true`.
     
     - parameter key: The key corresponding to the registration to resolve
     - parameter parameter: The parameter to pass to the registered resolution block when resolving
     - parameter cached: The desired caching behavior, as discussed above
     
     - returns: The resolved registration or `nil` if it was not found.
     */
    public static func resolve<T>(key: Key<T>, parameter: Any = (), cached: Bool? = nil) -> T? {
        let key = AnyKey(key)!
        guard let registration = lock.read({ registrations[key] }) else { return nil }
        return registration.resolve(parameter: parameter, cached: cached)
    }
    
    /**
     Locate and resolve multiple registrations of type `T`.
     
     If any of the `keys` is not registered, it will simply be skipped. This means that `keys.count`
     may not be equal to the `count` of the result. In addition, this overload returns `[Key<T>: T]`,
     which allows the caller to check which keys were returned in the output.
     
     Because only one `parameter` can be passed, the caller must ensure that all registered resolution
     blocks are compatible with this parameter.
     
     By default, `cached` is `nil`, which means that the registered value of `cached` is used. If
     `cached` is `false` but the original registered value is `true`, the cached value is skipped
     and a new instance of `T` is created. If `cached` is `true` but the registered value of `cached`
     is `false`, a cached instance will be created for use whenever `resolve` is called with `cached` == `true`.
     
     This method is typically used when resolving multiple "uniform" registrations, all of which take the
     same parameter and have the same caching behavior.
     
     - parameter keys: The set of keys to resolve
     - parameter parameter: The parameter passed to the registered resolution blocks when resolving
     - parameter cached: The desired caching behavior
     
     - returns: A dictionary mapping each key to its resolved instance of `T`
     
     - note: This method is typically used to resolve the results of `filter`. For instance, to
     find all of the registrations of type `Plugin` whose `container` is `Container.plugins` and
     then resolve them:
     
     ```swift
     // Registration - These plugins are registered
     // anonymously using UUID.
     let container = Container.plugins
     _ = Guise.register(name: UUID(), container: container) {
         Plugin1() as Plugin
     }
     _ = Guise.register(name: UUID(), container: container) {
         Plugin2() as Plugin
     }
     
     // Resolution
     let keys = Guise.filter(type: Plugin.self, container: container)
     let plugins: [Key<Plugin>: Plugin] = Guise.resolve(keys: keys)
     ```
     */
    public static func resolve<T>(keys: Set<Key<T>>, parameter: Any = (), cached: Bool? = nil) -> [Key<T>: T] {
        let keys = keys.map{ AnyKey($0)! }
        let filtered = lock.read{ registrations.filter{ keys.contains($0.key) } }
        return filtered.map{ (key: Key($0.key)!, value: $0.value.resolve(parameter: parameter, cached: cached)) }.dictionary()
    }

    /**
     Locate and resolve multiple registrations of type `T`.
     
     If any of the `keys` is not registered, it will simply be skipped. This means that `keys.count`
     may not be equal to the `count` of the result.
     
     - parameter keys: The set of keys to resolve
     - parameter parameter: The parameter passed to the registered resolution blocks when resolving
     - parameter cached: The desired caching behavior
     
     - returns: An array of resolved instances of `T`
     
     - note: This method is typically used to resolve the results of `filter`. For instance, to
     find all of the registrations of type `Plugin` whose `container` is `Container.plugins` and
     then resolve them:
     
     ```swift
     // Registration - These plugins are registered
     // anonymously using UUID.
     let container = Container.plugins
     _ = Guise.register(name: UUID(), container: container) {
     Plugin1() as Plugin
     }
     _ = Guise.register(name: UUID(), container: container) {
     Plugin2() as Plugin
     }
     
     // Resolution
     let keys = Guise.filter(type: Plugin.self, container: container)
     let plugins: [Plugin] = Guise.resolve(keys: keys)
     ```
     */
    public static func resolve<T>(keys: Set<Key<T>>, parameter: Any = (), cached: Bool? = nil) -> [T] {
        return Array(resolve(keys: keys, parameter: parameter, cached: cached).values)
    }
}

