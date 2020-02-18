//
//  ImpotentResolver.swift
//  Guise
//
//  Created by Gregory Higley on 12/12/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 A resolver that does nothing. All calls to
 `resolve` return `nil`. All calls to `resolve(into:)`
 return the target unmodified.
 
 What's the point? In your unit tests, you may not want to
 use a resolver. You may want to set your dependencies manually
 either by setting properties or calling constructors explicitly.
 
 Consider a view controller which uses KeyPath injection. In
 `viewDidLoad` we call `resolve(into:)` to hydrate our dependencies:
 
 ```
 var api: Api! // A KeyPath dependency
 
 override func viewDidLoad() {
    super.viewDidLoad()
    Guise.resolve(into: self)
 }
 ```
 
 If we use the `ImpotentResolver`, the dependency won't be hydrated and
 we will have to set it manually, e.g.,
 
 ```
 Guise.resolver = ImpotentResolver()
 let vc = ViewController()
 _ = vc.view // Implicitly loads the view, calling viewDidLoad.
 vc.api = Api()
 ```
 */
public final class ImpotentResolver: Resolving {
    public init() {}
    
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
    @discardableResult public func register<ParameterType, HoldingType: Holder>(key: Key<HoldingType.Held>, metadata: Any, cached: Bool, resolution: @escaping Resolution<ParameterType, HoldingType>) -> Key<HoldingType.Held> {
        return key
    }
    
    /**
     Unregisters the blocks registered under the given keys, if any.
     
     - parameter keys: The keys whose blocks should be unregistered.
     - returns: The number of registrations removed.
     */
    @discardableResult public func unregister<Keys: Sequence>(keys: Keys) -> Int where Keys.Element: Keyed {
        return 0
    }

    /// The root filter method. All other filter methods build upon this one.
    public func filter<K: Keyed>(_ filter: @escaping (K) -> Bool) -> [K: Registration] {
        return [:]
    }
    
    /// Returns the keys of the registered injections. Injection keys are just strings.
    public var injectables: Set<String> {
        return []
    }

    /**
     Registers an injection.
     
     An injection is a function that transforms and then returns its argument. If the
     argument is a reference type, conforming injections must return the _same_ reference.
     If the injection does not apply to the passed-in instance, the instance should be
     returned unmodified.
     
     For example, here is a properly written injection that adds two to any integer passed to it.
     
     ```
     Guise.register(injectable: "AddTwo") { arg in
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
     
     - note: Don't use this method. It is the foundation on which higher-level, more type-safe
     forms of injection are built.
     
     - parameter key: The unique key under which this injection is registered.
     - parameter injection: The injection to register.
     
     - returns: The key under which the registration was made.
     */
    public func register(injectable: String, injection: @escaping Injection<AnyObject>) -> String {
        return injectable
    }
    
    /**
     Resolves any injections which apply to `target`.
     
     _All_ registered injections are tested against `target` and applied if applicable. See
     the documentation for `register(injectable:injection:)` for more information.
     */
    public func resolve(into target: AnyObject) {
        
    }
    
    /**
     Unregisters the registered injections.
     
     - parameter injectables: The keys of the registered injections.
     - returns: The number of injections removed.
     */
    public func unregister<Keys>(injectables: Keys) -> Int where Keys : Sequence, Keys.Element == String {
        return 0
    }

}
