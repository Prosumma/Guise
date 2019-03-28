//
//  Register.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolving {
    
    /**
     Registers a resolution block that returns a `Holder`. In most cases, this method should be avoided
     and instead one of the other overloads of `register` should be used, such as `register(type:)`,
     `register(instance:)`, `register(factory:)`, or `register(weak:)`.
     */
    @discardableResult func register<ParameterType, HoldingType: Holder>(key: Key<HoldingType.Held>, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<ParameterType, HoldingType>) -> Key<HoldingType.Held> {
        return register(key: key, metadata: metadata, cached: cached, resolution: resolution)
    }
    
    /**
     Registers a resolution block using an explicit `key`. In most cases, this method should be avoided
     and instead one of the other overloads of `register` should be used, such as `register(type:)`,
     `register(instance:)`, `register(factory:)`, or `register(weak:)`.
     */
    @discardableResult func register<ParameterType, RegisteredType>(key: Key<RegisteredType>, metadata: Any = (), cached: Bool = false, resolution: @escaping (ParameterType) -> RegisteredType) -> Key<RegisteredType> {
        return register(key: key, metadata: metadata, cached: cached) { Strong(resolution($0)) }
    }

    /**
     Registers a `Holder` directly. In most cases, this method should be avoided and instead
     one of the other overloads of `register` used, such as `register(instance:)`,
     `register(factory:)`, or `register(weak:)`.
     */
    @discardableResult func register<HoldingType: Holder>(holder: @escaping @autoclosure () -> HoldingType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = (), cached: Bool = false) -> Key<HoldingType.Held> {
        let key = Key<HoldingType.Held>(name: name, container: container)
        return register(key: key, metadata: metadata, cached: cached, resolution: holder)
    }
    
    /**
     Registers a resolution block that returns a `Holder`. In most cases, this method should be avoided
     and instead one of the other overloads of `register` should be used, such as `register(type:)`,
     `register(instance:)`, `register(factory:)`, or `register(weak:)`.
     */
    @discardableResult func register<ParameterType, HoldingType: Holder>(type: HoldingType.Held.Type = HoldingType.Held.self, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<ParameterType, HoldingType>) -> Key<HoldingType.Held> {
        let key = Key<HoldingType.Held>(name: name, container: container)
        return register(key: key, metadata: metadata, cached: cached, resolution: resolution)
    }
    
    /**
     Registers a resolution block.
     
     This overload is useful when the resolution block has a parameter:
     
     ```
     Guise.register { (x: Int) in Foo(x: x) }
     ```
     
     In most other cases, it is best to use one of the other `register`
     overloads, such as `register(instance:)`, `register(factory:)`, or
     `register(weak:)`.
     
     - parameter key: The unique `Key` for this registration.
     - parameter metadata: Arbitrary metadata associated with this registration.
     - parameter cached: Whether or not to cache the registered instance.
     - parameter resolution: The block to register.
     
     - returns: The unique `Key` under which the registration was made.
     */
    @discardableResult func register<ParameterType, RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<ParameterType, RegisteredType>) -> Key<RegisteredType> {
        return register(key: Key<RegisteredType>(name: name, container: container), metadata: metadata, cached: cached, resolution: resolution)
    }
    
    /**
     Creates a strong registration with Guise.
     
     It's probably best to use `register(instance:)` or `register(factory:)` instead of
     `register(strong:)`. This overload's chief claim to fame is that caching can be
     decided up front *and* during resolution:
     
     ```
     Guise.register(strong: Foo(), cached: true)
     ```
     
     Here we register a `Foo` and specify that it should be cached. This is almost
     exactly equivalent to `Guise.register(instance: Foo())` except that when resolving
     a registration made with `register(instance:)`, the cached value is *always* returned,
     even if the caller specifies `cached: false`. With `register(strong:)`, `cached: false`
     is honored.
     
     ```
     let foo = Guise.resolve(type: Foo.self, cached: false)
     ```
     
     If the above registration was made with `register(strong:)`, the resolution block
     will be called again even if the registration was made with `cached: true`. However,
     if the above registration was made with `register(instance:)`, the value of `cached`
     is ignored and the cached instance is always returned.
     
     Similar semantics apply to `register(factory:)`, but in reverse.
     
     - parameter strong: The strong instance to register
     - parameter name: The name under which to create the registration
     - parameter container: The container in which to create the registration
     - parameter metadata: Arbitrary metadata to associate with the registration
     - parameter cached: Whether or not the registration should be cached after it is first resolved
     
     - returns: The key under which the registration was made
     */
    @discardableResult func register<RegisteredType>(strong: @escaping @autoclosure () -> RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = (), cached: Bool = false) -> Key<RegisteredType> {
        return register(holder: Strong(strong()), name: name, container: container, metadata: metadata, cached: cached)
    }
    
    /**
     Creates a factory registration with Guise.
     
     In a factory registration, a new instance is created every time resolution occurs.
     This cannot be overridden by passing `cached: false` to `resolve`.
     
     - parameter factory: The factory to register
     - parameter name: The name under which to create the registration
     - parameter container: The container in which to create the registration
     - parameter metadata: Arbitrary metadata to associate with the registration
     
     - returns: The key under which the registration was made
     */
    @discardableResult func register<RegisteredType>(factory: @escaping @autoclosure () -> RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<RegisteredType> {
        return register(holder: Uncached(factory()), name: name, container: container, metadata: metadata, cached: false)
    }

    /**
     Creates an instance registration with Guise.
     
     In an instance registration, the cached value is always returned. This cannot be
     overridden by passing `cached: false` to `resolve`. Effectively, instance
     registration creates a singleton inside of the resolver. Use this method when
     you want one and the same instance to be returned every time resolution occurs.
     
     - note: It can still be useful to register value types this way. Resolution will give
     a copy, but the initializer won't be called except the very first time.
     
     - parameter instance: The instance to register
     - parameter name: The name under which to create the registration
     - parameter container: The container in which to create the registration
     - parameter metadata: Arbitrary metadata to associate with the registration
     
     - returns: The key under which the registration was made
     */
    @discardableResult func register<RegisteredType>(instance: @escaping @autoclosure () -> RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<RegisteredType> {
        return register(holder: Cached(instance()), name: name, container: container, metadata: metadata, cached: true)
    }
    
    /**
     Creates a weak registration with Guise.
     
     Unlike overloads such as `register(factory:)` and `register(instance:)`, the argument of
     `register(weak:)` cannot be lazily evaluated and must already exist.
     
     It must also be a reference type. If not, resolution always returns `nil`.
     
     ```
     class MyViewController: UIViewController {
         override func viewDidLoad() {
            super.viewDidLoad()
            Guise.register(weak: self)
         }
     }
     ```
     
     - parameter weak: The weak reference to register
     - parameter name: The name under which to create the registration
     - parameter container: The container in which to create the registration
     - parameter metadata: Arbitrary metadata to associate with the registration
     
     - returns: The key under which the registration was made
     */
    @discardableResult func register<RegisteredType>(weak instance: RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<RegisteredType> {
        // This must be done in two steps, otherwise the block will capture the instance parameter and it will
        // not be weakly held.
        let weakling = Weak(instance)
        return register(holder: weakling, name: name, container: container, metadata: metadata)
    }

}

public extension _Guise {
    
    /**
     Registers a resolution block that returns a `Holder`. In most cases, this method should be avoided
     and instead one of the other overloads of `register` should be used, such as `register(type:)`,
     `register(instance:)`, `register(factory:)`, or `register(weak:)`.
     */
    @discardableResult static func register<ParameterType, HoldingType: Holder>(key: Key<HoldingType.Held>, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<ParameterType, HoldingType>) -> Key<HoldingType.Held> {
        return resolver.register(key: key, metadata: metadata, cached: cached, resolution: resolution)
    }
    
    /**
     Registers a resolution block using an explicit `key`. In most cases, this method should be avoided
     and instead one of the other overloads of `register` should be used, such as `register(type:)`,
     `register(instance:)`, `register(factory:)`, or `register(weak:)`.
     */
    @discardableResult static func register<ParameterType, RegisteredType>(key: Key<RegisteredType>, metadata: Any = (), cached: Bool = false, resolution: @escaping (ParameterType) -> RegisteredType) -> Key<RegisteredType> {
        return resolver.register(key: key, metadata: metadata, cached: cached, resolution: resolution)
    }
    
    /**
     Registers a `Holder` directly. In most cases, this method should be avoided and instead
     one of the other overloads of `register` used, such as `register(instance:)`,
     `register(factory:)`, or `register(weak:)`.
     */
    @discardableResult static func register<HoldingType: Holder>(holder: @escaping @autoclosure () -> HoldingType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = (), cached: Bool = false) -> Key<HoldingType.Held> {
        return resolver.register(holder: holder(), name: name, container: container, metadata: metadata, cached: cached)
    }

    /**
     Registers a resolution block that returns a `Holder`. In most cases, this method should be avoided
     and instead one of the other overloads of `register` should be used, such as `register(type:)`,
     `register(instance:)`, `register(factory:)`, or `register(weak:)`.
     */
    @discardableResult static func register<ParameterType, HoldingType: Holder>(type: HoldingType.Held.Type = HoldingType.Held.self, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<ParameterType, HoldingType>) -> Key<HoldingType.Held> {
        return resolver.register(type: type, name: name, container: container, metadata: metadata, cached: cached, resolution: resolution)
    }
    
    /**
     Registers a resolution block.
     
     This overload is useful when the resolution block has a parameter:
     
     ```
     Guise.register { (x: Int) in Foo(x: x) }
     ```
     
     In most other cases, it is best to use one of the other `register`
     overloads, such as `register(instance:)`, `register(factory:)`, or
     `register(weak:)`.
     
     - parameter key: The unique `Key` for this registration.
     - parameter metadata: Arbitrary metadata associated with this registration.
     - parameter cached: Whether or not to cache the registered instance.
     - parameter resolution: The block to register.
     
     - returns: The unique `Key` under which the registration was made.
     */
    @discardableResult static func register<Parameter, RegisteredType>(type: RegisteredType.Type = RegisteredType.self, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<Parameter, RegisteredType>) -> Key<RegisteredType> {
        return resolver.register(type: type, name: name, container: container, metadata: metadata, cached: cached, resolution: resolution)
    }
    
    /**
     Creates a strong registration with Guise.
     
     It's probably best to use `register(instance:)` or `register(factory:)` instead of
     `register(strong:)`. This overload's chief claim to fame is that caching can be
     decided up front *and* during resolution:
     
     ```
     Guise.register(strong: Foo(), cached: true)
     ```
     
     Here we register a `Foo` and specify that it should be cached. This is almost
     exactly equivalent to `Guise.register(instance: Foo())` except that when resolving
     a registration made with `register(instance:)`, the cached value is *always* returned,
     even if the caller specifies `cached: false`. With `register(strong:)`, `cached: false`
     is honored.
     
     ```
     let foo = Guise.resolve(type: Foo.self, cached: false)
     ```
     
     If the above registration was made with `register(strong:)`, the resolution block
     will be called again even if the registration was made with `cached: true`. However,
     if the above registration was made with `register(instance:)`, the value of `cached`
     is ignored and the cached instance is always returned.
     
     Similar semantics apply to `register(factory:)`, but in reverse.
     
     - parameter strong: The strong instance to register
     - parameter name: The name under which to create the registration
     - parameter container: The container in which to create the registration
     - parameter metadata: Arbitrary metadata to associate with the registration
     - parameter cached: Whether or not the registration should be cached after it is first resolved
     
     - returns: The key under which the registration was made
     */
    @discardableResult static func register<RegisteredType>(strong: @escaping @autoclosure () -> RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = (), cached: Bool = false) -> Key<RegisteredType> {
        return resolver.register(holder: Strong(strong()), name: name, container: container, metadata: metadata, cached: cached)
    }
    
    /**
     Creates a factory registration with Guise.
     
     In a factory registration, a new instance is created every time resolution occurs.
     This cannot be overridden by passing `cached: false` to `resolve`.
     
     - parameter factory: The factory to register
     - parameter name: The name under which to create the registration
     - parameter container: The container in which to create the registration
     - parameter metadata: Arbitrary metadata to associate with the registration
     
     - returns: The key under which the registration was made
     */
    @discardableResult static func register<RegisteredType>(factory: @escaping @autoclosure () -> RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<RegisteredType> {
        return resolver.register(holder: Uncached(factory()), name: name, container: container, metadata: metadata)
    }
    
    /**
     Creates an instance registration with Guise.
     
     In an instance registration, the cached value is always returned. This cannot be
     overridden by passing `cached: false` to `resolve`. Effectively, instance
     registration creates a singleton inside of the resolver. Use this method when
     you want one and the same instance to be returned every time resolution occurs.
     
     - note: It can still be useful to register value types this way. Resolution will give
     a copy, but the initializer won't be called except the very first time.
     
     - parameter instance: The instance to register
     - parameter name: The name under which to create the registration
     - parameter container: The container in which to create the registration
     - parameter metadata: Arbitrary metadata to associate with the registration
     
     - returns: The key under which the registration was made
     */
    @discardableResult static func register<RegisteredType>(instance: @escaping @autoclosure () -> RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<RegisteredType> {
        return resolver.register(holder: Cached(instance()), name: name, container: container, metadata: metadata)
    }

    /**
     Creates a weak registration with Guise.
     
     Unlike overloads such as `register(factory:)` and `register(instance:)`, the argument of
     `register(weak:)` cannot be lazily evaluated and must already exist.
     
     It must also be a reference type. If not, resolution always returns `nil`.
     
     ```
     class MyViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            Guise.register(weak: self)
        }
     }
     ```
     
     - parameter weak: The weak reference to register
     - parameter name: The name under which to create the registration
     - parameter container: The container in which to create the registration
     - parameter metadata: Arbitrary metadata to associate with the registration
     
     - returns: The key under which the registration was made
     */
    @discardableResult static func register<RegisteredType>(weak instance: RegisteredType, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, metadata: Any = ()) -> Key<RegisteredType> {
        return resolver.register(weak: instance, name: name, container: container, metadata: metadata)
    }    
}
