//
//  Register.swift
//  Guise
//
//  Created by Gregory Higley on 9/3/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

// Block registration
extension Guise {
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
    public static func register<P, T>(keys: Set<Key<T>>, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<P, T>) -> Set<Key<T>> {
        return lock.write {
            for key in keys {
                registrations[AnyKey(key)!] = Registration(metadata: metadata, cached: cached, resolution: resolution)
            }
            return keys
        }
    }
    
    /**
     Register a resolution block with a single key.
     
     - parameter key: The key under which to register the resolution block
     - parameter metadata: Optional arbitrary metadata attached to the registration
     - parameter cached: `true` means that the result of the resolution block is cached after it is first called.
     - parameter resolution: The resolution block to register
     
     - returns: The key under which the registration was made
     */
    public static func register<P, T>(key: Key<T>, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<P, T>) -> Key<T> {
        return register(keys: [key], metadata: metadata, cached: cached, resolution: resolution).first!
    }
    
    /**
     Register a resolution block.
     
     An implicit key is created using `T`, `name`, and `container`, which is then used to register the block.
     
     - parameter name: The name under which to register the block, defaulting to `Guise.Name.default`
     - parameter container: The container under which to register the block, default to `Guise.Container.default`
     - parameter metadata: Optional arbitrary metadata attached to the registration
     - parameter cached: `true` means that the result of the resolution block is cached after it is first called.
     - parameter resolution: The resolution block to register
     
     - returns: The key under which the registration was made
     */
    public static func register<P, T>(name: AnyHashable = Name.default, container: AnyHashable = Container.default, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<P, T>) -> Key<T> {
        return register(key: Key(name: name, container: container), metadata: metadata, cached: cached, resolution: resolution)
    }
}

// Instance registration
extension Guise {
    /**
     Register an instance of `T`.
     
     The `instance` parameter is actually an autoclosure, so it is evaluated lazily.
     Instance registration is cached.
     
     - parameter instance: The instance to register.
     - parameter key: The key under which to register the instance
     - parameter metadata: Optional arbitrary metadata attached to the registration
     
     - returns: The key under which the registration was made
     */
    public static func register<T>(instance: @escaping @autoclosure () -> T, key: Key<T>, metadata: Any = ()) -> Key<T> {
        return register(key: key, metadata: metadata, cached: true, resolution: instance)
    }
    
    /**
     Register an instance of `T`.
     
     The `instance` parameter is actually an autoclosure, so it is evaluated lazily.
     Instance registration is cached.
     
     - parameter instance: The instance to register.
     - parameter name: The name under which to register the instance
     - parameter container: The container in which to register the instance
     - parameter metadata: Optional arbitrary metadata attached to the registration
     
     - returns: The key under which the registration was made     
     */
    public static func register<T>(instance: @escaping @autoclosure () -> T, name: AnyHashable = Name.default, container: AnyHashable = Container.default, metadata: Any = ()) -> Key<T> {
        return register(instance: instance, key: Key(name: name, container: container), metadata: metadata)
    }
}

// Factory registration
extension Guise {
    /**
     Register a factory that makes `T` instances.
     
     This is very similar to instance registration, except that the result is _uncached_.
     The `factory` parameter is an autoclosure.
     
     - parameter factory: The factory to register
     - parameter key: The key under which to register the instance
     - parameter metadata: Optional arbitrary metadata attached to the registration
     
     - returns: The key under which the registration was made
     */
    public static func register<T>(factory: @escaping @autoclosure () -> T, key: Key<T>, metadata: Any = ()) -> Key<T> {
        return register(key: key, metadata: metadata, cached: false, resolution: factory)
    }

    /**
     Register a factory that makes `T` instances.
     
     This is very similar to instance registration, except that the result is _uncached_.
     The `factory` parameter is an autoclosure.
     
     - parameter factory: The factory to register
     - parameter name: The name under which to register the instance
     - parameter container: The container in which to register the instance
     - parameter metadata: Optional arbitrary metadata attached to the registration
     
     - returns: The key under which the registration was made
     */
    public static func register<T>(factory: @escaping @autoclosure () -> T, name: AnyHashable = Name.default, container: AnyHashable = Container.default, metadata: Any = ()) -> Key<T> {
        return register(factory: factory, key: Key(name: name, container: container), metadata: metadata)
    }
}
