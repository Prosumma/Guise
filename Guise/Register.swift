//
//  Register.swift
//  Guise
//
//  Created by Gregory Higley on 9/3/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 A protocol that allows types to be registered directly.
 
 Under the hood, Guise _always_ registers a block. However,
 if a type uses a parameterless initializer, which is a very
 common case, it can be convenient simply to specify the type.
 
 For example, in place of `_ = Guise.register{ Foo() }`, one could
 say `_ = Guise.register(type: Foo.self)` as long as `Foo` adopts
 the `Init` protocol.
 
 In the case where the type is aliased, for example in `_ = Guise.register{ Foo() as Bar }`,
 we can say `_ = Guise.register(type: Bar.self, for: Foo.self)`.
 `Foo` must still adopt `Init`.
 */
public protocol Init {
    init()
}

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
     
     - parameter instance: The instance to register.
     - parameter key: The key under which to register the instance
     - parameter metadata: Optional arbitrary metadata attached to the registration
     
     - returns: The key under which the registration was made
     */
    public static func register<T>(instance: T, key: Key<T>, metadata: Any = ()) -> Key<T> {
        return register(key: key, metadata: metadata, cached: true) { instance }
    }
    
    /**
     Register an instance of `T`.
     
     - parameter instance: The instance to register.
     - parameter name: The name under which to register the instance
     - parameter container: The container in which to register the instance
     - parameter metadata: Optional arbitrary metadata attached to the registration
     
     - returns: The key under which the registration was made
     */
    public static func register<T>(instance: T, name: AnyHashable = Name.default, container: AnyHashable = Container.default, metadata: Any = ()) -> Key<T> {
        return register(instance: instance, key: Key(name: name, container: container), metadata: metadata)
    }
}

// Type registration
extension Guise {
    /**
     Register the type `T`, which must implement `Init`.
     
     This is a convenience for registering a type with a simple parameterless initializer, which is a common case.
     
     - parameter type: The type to register
     - parameter key: The key under which to register the type
     - parameter metadata: Optional arbitrary metadata attached to the registration
     - parameter cached: `true` means that the result of the resolution block is cached after it is first called.
     
     - returns: The key under which the registration was made
     */
    public static func register<T: Init>(type: T.Type, key: Key<T>, metadata: Any = (), cached: Bool = false) -> Key<T> {
        return register(key: key, metadata: metadata, cached: cached, resolution: T.init)
    }
    
    /**
     Register the type `T`, which must implement `Init`.
     
     This is a convenience for registering a type with a simple parameterless initializer, which is a common case.
     
     - parameter type: The type to register
     - parameter name: The name under which to register the type, defaulting to `Guise.Name.default`
     - parameter container: The container under which to register the type, defaulting to `Guise.Container.default`
     - parameter metadata: Optional arbitrary metadata attached to the registration
     - parameter cached: `true` means that the result of the resolution block is cached after it is first called.
     
     - returns: The key under which the registration was made
     */
    public static func register<T: Init>(type: T.Type, name: AnyHashable = Name.default, container: AnyHashable = Container.default, metadata: Any = (), cached: Bool = false) -> Key<T> {
        return register(type: T.self, key: Key(name: name, container: container), metadata: metadata, cached: cached)
    }
    
    /**
     Register the implementation `I` conforming to `T`. `I` must implement `Init`.
     
     In general, `T` is an abstract type such as a protocol, and `I` is its concrete implementation.
     
     - parameter type: The type to register
     - parameter impl: The implementation to register
     - parameter key: The key under which to register the type
     - parameter metadata: Optional arbitrary metadata attached to the registration
     - parameter cached: `true` means that the result of the resolution block is cached after it is first called.
     
     - returns: The key under which the registration was made
     
     - warning: `I` must implement or be a subtype of `T`. Swift's type system is currently unable to handle this constraint explicitly.
     If `I` cannot be cast to `T` with `as!`, an unrecoverable runtime exception will occur.
     */
    public static func register<T, I: Init>(type: T.Type, impl: I.Type, key: Key<T>, metadata: Any = (), cached: Bool = false) -> Key<T> {
        return register(key: key, metadata: metadata, cached: cached) { I() as! T }
    }
    
    /**
     Register the implementation `I` conforming to `T`. `I` must implement `Init`.
     
     In general, `T` is an abstract type such as a protocol, and `I` is its concrete implementation.
     
     - parameter type: The type to register
     - parameter impl: The implementation to register
     - parameter name: The name under which to register the type
     - parameter container: The container in which to register the type
     - parameter metadata: Optional arbitrary metadata attached to the registration
     - parameter cached: `true` means that the result of the resolution block is cached after it is first called.
     
     - returns: The key under which the registration was made
     
     - warning: `I` must implement or be a subtype of `T`. Swift's type system is currently unable to handle this constraint explicitly.
     If `I` cannot be cast to `T` with `as!`, an unrecoverable runtime exception will occur.
     */
    public static func register<T, I: Init>(type: T.Type, impl: I.Type, name: AnyHashable = Name.default, container: AnyHashable = Container.default, metadata: Any = (), cached: Bool = false) -> Key<T> {
        return register(type: T.self, impl: I.self, key: Key(name: name, container: container), metadata: metadata, cached: cached)
    }
}


