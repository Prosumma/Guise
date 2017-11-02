//
//  Resolving.swift
//  Guise
//
//  Created by Gregory Higley on 11/1/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/// The minimum protocol required by a Resolver
public protocol Resolving {
    /// Returns all registered keys
    var keys: Set<AnyKey> { get }
    
    /**
     Register a single resolution block with multiple keys. All of the keys must have the same type `T`, but may have
     different values for `name` and `container`.
     
     Direct use of this method will most likely be rare. However, it is the "master" registration method. All other registration
     methods ultimately call this one.
     
     - parameter keys: The set of keys under which to register the block
     - parameter metadata: Optional arbitrary metadata attached to the registration
     - parameter cached: `true` means that the result of the resolution block is cached after it is first called.
     - parameter resolution: The resolution block to register
     
     - returns: The keys under which the registrations were made
     */
    @discardableResult func register<P, T>(keys: Set<Key<T>>, metadata: Any, cached: Bool, resolution: @escaping Resolution<P, T>) -> Set<Key<T>>
    
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
    func resolve<T>(keys: Set<Key<T>>, parameter: Any, cached: Bool?) -> [Key<T>: T]
    
    /**
     Match by filter criteria and optional metafilter.
     
     - parameter criteria: The filter criteria to match
     - parameter metafilter: The metafilter query to apply
     
     - returns: The matched keys
     */
    func filter<K: Keyed>(criteria: Set<Criterion>, metafilter: Metafilter<Any>?) -> Set<K>
    
    /**
     Remove registrations by key.
     
     - parameter keys: The keys to remove
     - returns: The number of registrations removed
     */
    @discardableResult func unregister<K: Keyed>(keys: Set<K>) -> Int
    
    /**
     Retrieve metadata for the given key.
     
     The `type` parameter does not have to be exactly the same as the type
     of the registered metadata. It simply has to be type-compatible. If it is
     not, `nil` is returned.
     
     - parameter key: The key for which to retrieve the metadata
     - parameter metatype: The type of the metadata to retrieve
     
     - returns: The metadata or `nil` if it is not found
     */
    func metadata<K: Keyed, M>(forKey key: K, metatype: M.Type) -> M?
}
