//
//  Guise.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 The Guise type. Use its static methods.
 
 The most convenient way to use Guise is to use
 the static methods of the `Guise` type, e.g.,
 
 ```
 Guise.register(factory: Foo())
 ```
 
 The other way is simply to create a `Resolver` instance
 and pass it around, e.g.,
 
 ```
 let resolver = Resolver()
 resolver.register(factory: Foo())
 ```
 
 Under the hood, the `Guise` type does exactly this. It has
 a static `resolver` property which is initialized to the default
 resolver. All of its static methods simply forward to this
 resolver. It is possible to reassign this resolver, e.g.,
 
 ```
 Guise.resolver = ImpotentResolver()
 ```
 */
public struct Guise: _Guise {
    
    public enum Name {
        /// The default name for registrations in which the name is not specified.
        case `default`
    }
    
    public enum Container {
        /// The default container for registrations in which the container is not specified.
        case `default`
    }

    /// Used in the `clear` method to decide what to clear.
    public struct Clear: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let registrations = Clear(rawValue: 1 << 0)
        public static let injections = Clear(rawValue: 1 << 1)
        public static let both: Clear = [.registrations, .injections]
    }
    
    /// The default resolver. Can be reassigned to any type that implements `Resolving`.
    public static var resolver: Resolving = Resolver()
    
    /**
     Registers a resolution block that returns a `Holder`.
     
     - warning: Caching behavior may be forcibly overriden by the
     `Holder` that is used. The `Cached` holder ignores the value
     of the `cached` parameter and _always_ returns a cached value.
     
     - parameter key: The unique `Key` for this registration.
     - parameter metadata: Arbitrary metadata associated with this registration.
     - parameter cached: Whether or not to cache the registered instance.
     - parameter resolution: The block to register.
     
     - returns: The unique `Key` under which the registration was made.
     */
    @discardableResult public static func register<ParameterType, HoldingType: Holder>(key: Key<HoldingType.Held>, metadata: Any, cached: Bool, resolution: @escaping Resolution<ParameterType, HoldingType>) -> Key<HoldingType.Held> {
        return resolver.register(key: key, metadata: metadata, cached:cached, resolution: resolution)
    }

    /**
     Unregisters the blocks registered under the given keys, if any.
     
     - parameter keys: The keys whose blocks should be unregistered.
     - returns: The number of registrations removed.
     */
    @discardableResult public static func unregister<Keys: Sequence>(keys: Keys) -> Int where Keys.Element: Keyed {
        return resolver.unregister(keys: keys)
    }

    /// The root filter method. All other filter methods build upon this one.
    public static func filter<K: Keyed>(_ filter: @escaping (K) -> Bool) -> [K: Registration] {
        return resolver.filter(filter)
    }
    
    /// Returns the keys of the registered injections. Injection keys are just strings.
    public static var injectables: Set<String> {
        return resolver.injectables
    }
    
    /**
     Registers an injection.
     
     An injection is a function that transforms and then returns its argument. If the
     argument is a reference type, conforming injections must return the _same_ reference.
     If the injection does not apply to the passed-in instance, the instance should be
     returned unmodified. An injection takes two parameters: The first is the target
     of the injection. The second is the resolver with which the injection is registered.
     
     For example, here is a properly written injection that adds two to any integer passed to it.
     In this example, we are ignoring the resolver passed as the second argument to the injection.
     
     ```
     Guise.register(injectable: "AddTwo") { (target, _) in
     guard let i = arg as? Int else { return arg }
     return i + 2
     }
     ```
     
     The first line of the injection is critically important. When `resolve` is called, every
     registered injection is tried. Those that do not apply will simply bail if properly written:
     
     ```
     var s = "ok"
     s = Guise.resolve(into: s)
     ```
     
     If our "AddTwo" injection was registered, it would simply return its argument.
     
     - warning: Don't use this method. It is the foundation on which higher-level, more type-safe
     forms of injection are built. Use any of the other overloads, but especially those
     that take keypaths.
     
     - parameter key: The unique key under which this injection is registered.
     - parameter injection: The injection to register.
     
     - returns: The key under which the registration was made.
     */
    @discardableResult public static func register(injectable key: String, injection: @escaping Injection<AnyObject>) -> String {
        return resolver.register(injectable: key, injection: injection)
    }
    
    /**
     Resolves any injections which apply to `target`.
     
     _All_ registered injections are tested against `target` and applied if applicable. See
     the documentation for `register(injectable:injection:)` for more information.
     */
    public static func resolve(into target: AnyObject) {
        resolver.resolve(into: target)
    }
    
    /**
     Unregisters the registered injections.
     
     - parameter injectables: The keys of the registered injections.
     - returns: The number of injections removed.
     */
    @discardableResult public static func unregister<Keys: Sequence>(injectables: Keys) -> Int where Keys.Element == String {
        return resolver.unregister(injectables: injectables)
    }
}
