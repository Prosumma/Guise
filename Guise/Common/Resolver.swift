//
//  Resolver.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 The core of Guise.
 
 `Resolver` is the class that does all of Guise's heavy lifting.
 The `Guise` type uses an instance of `Resolver` under the hood
 and forwards all operations to it.
 
 In most cases, just use the static methods of the `Guise` type,
 but if you prefer, you can create a `Resolver` directly and
 simply use it:
 
 ```
 let resolver = Resolver()
 resolver.register(factory: Foo())
 ```
 */
public final class Resolver: Resolving {

    internal var lock = Lock()
    
    // MARK: Initialization
    
    public init() {}
    
    // MARK: Registrations
    
    internal var registrations = [AnyKey: Registration]()
    
    /**
     Gets the registered keys.
     
     Keys are unique identifiers for block registrations.
     (Injections just use strings as keys.)
     
     This returns a `Set` of `AnyKey` instances, because
     the keys may register heterogeneous types.
     
     See `Keyed`, `AnyKey`, `Key<T>` and the various
     `register` overloads for more information on keys.
     */
    public var keys: Set<AnyKey> {
        return Set(lock.read{ registrations.keys })
    }
    
    /// Returns the `Registration` (if any) registered under `key`.
    public func filter<K: Keyed & Hashable>(key: K) -> Registration? {
        let key = AnyKey(key)!
        return lock.read{ registrations[key] }
    }
    
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
    @discardableResult public func register<RegisteredType, ParameterType, HoldingType: Holder>(key: Key<RegisteredType>, metadata: Any, cached: Bool, resolution: @escaping Resolution<ParameterType, HoldingType>) -> Key<RegisteredType> where HoldingType.Held == RegisteredType {
        lock.write { registrations[AnyKey(key)!] = _Registration(metadata: metadata, cached: cached, resolution: resolution) }
        return key
    }
    
    /**
     Unregisters the blocks registered under the given keys, if any.
     
     - parameter keys: The keys whose blocks should be unregistered.
     - returns: The number of registrations removed.
     */
    @discardableResult public func unregister<Keys: Sequence>(keys: Keys) -> Int where Keys.Element: Keyed {
        return lock.write {
            let count = registrations.count
            registrations = registrations.filter{ element in !keys.contains{ $0 == element.key } }
            return count - registrations.count
        }
    }

    /// The root filter method. All other filter methods build upon this one.
    public func filter<K: Keyed>(_ filter: @escaping (K) -> Bool) -> [K: Registration] {
        return lock.read {
            var result = [K: Registration]()
            for element in registrations {
                guard let key = K(element.key), filter(key) else { continue }
                result[key] = element.value
            }
            return result
        }
    }
    
    // MARK: Injecting
    
    internal var injections = [String: Injection<AnyObject>]()

    /// Returns the keys of the registered injections. Injection keys are just strings.
    public var injectables: Set<String> {
        return Set(lock.read{ injections.keys })
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
    @discardableResult public func register(injectable key: String, injection: @escaping Injection<AnyObject>) -> String {
        lock.write { injections[key] = injection }
        return key
    }
    
    /**
     Resolves any injections which apply to `target`.
     
     _All_ registered injections are tested against `target` and applied if applicable. See
     the documentation for `register(injectable:injection:)` for more information.
     */
    public func resolve(into target: AnyObject) {
        let injections = lock.read{ self.injections.values }
        for injection in injections {
            injection(target, self)
        }
    }
    
    /**
     Unregisters the registered injections.
     
     - parameter injectables: The keys of the registered injections.
     - returns: The number of injections removed.
     */
    @discardableResult public func unregister<Keys: Sequence>(injectables: Keys) -> Int where Keys.Element == String {
        return lock.write {
            let count = injections.count
            injections = injections.filter{ !injectables.contains($0.key) }
            return count - injections.count
        }
    }
    
}

