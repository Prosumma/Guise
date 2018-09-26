//
//  Injector.swift
//  Guise
//
//  Created by Gregory Higley on 12/12/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 Assists in the construction of `KeyPath` injection chains.
 
 See the `into(injectable:)` method of `Resolving` for more information.
 */
public struct Injector<Target> {
    let resolver: Resolving
    var injections = [Injection<Target>]()
    
    internal init(resolver: Resolving) {
        self.resolver = resolver
    }

    /**
     Injects an explicit injection into the injection chain. This allows
     more complex injections to be specified.
     
     ```
     Guise.into(injectable: Foo.self)
        .inject(\.bar)
        .inject { (target, resolver) in
            if target.level < 3 { return target }
            target.foo = resolver.resolve()
            return target
        }
        .register()
     ```
     */
    public func inject(injection: @escaping Injection<Target>) -> Injector<Target> {
        var injector = self
        injector.injections.append(injection)
        return injector
    }
    
    /**
     Registers a non-optional `KeyPath` injection that is satisfied by the given `key`.
     
     ```
     .inject(exact: \.api, key: Key(name: Name.api2))
     ```
     
     Most `KeyPath` injections hydrate optionals, e.g.,
     
     ```
     class MyAwesomeViewController {
        var api: Api!
         override func viewDidLoad() {
            super.viewDidLoad()
            Guise.resolve(into: self)
         }
     }
     ```
     
     In the unusual case that a dependency is not an optional, this overload (and its
     `inject(exact:)` relatives) should be used.
     
     - note: It's best to use the other, more convenient `inject(exact:)` overloads.
     */
    public func inject<RegisteredType>(exact keyPath: WritableKeyPath<Target, RegisteredType>, key: Key<RegisteredType>, cached: Bool? = nil) -> Injector<Target> {
        return inject { (target, resolver) in
            var target = target
            guard let resolved = resolver.resolve(key: key, cached: cached) else { return target }
            target[keyPath: keyPath] = resolved
            return target
        }
    }
    
    /**
     Registers a non-optional `KeyPath` injection that is satisfied by the
     registration with the given `RegisteredType`, `name`, and `container`.
     
     ```
     .inject(exact: \.foo, container: Container.plugins)
     ```
     */
    public func inject<RegisteredType>(exact keyPath: WritableKeyPath<Target, RegisteredType>, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Injector<Target> {
        return inject(exact: keyPath, key: Key<RegisteredType>(name: name, container: container), cached: cached)
    }
    
    /**
     Registers a non-optional `KeyPath` injection that is satisfied by the given `key`.
     
     ```
     .inject(exact: \.api, key: Key(name: Name.api2))
     ```
     
     Most `KeyPath` injections hydrate optionals, e.g.,
     
     ```
     class MyAwesomeViewController {
         var api: Api!
         override func viewDidLoad() {
             super.viewDidLoad()
             Guise.resolve(into: self)
         }
     }
     ```
     
     In the unusual case that a dependency is not an optional, this overload (and its
     `inject(exact:)` relatives) should be used.
     
     - note: It's best to use the other, more convenient `inject(exact:)` overloads.
     */
    public func inject<RegisteredType>(exact keyPath: ReferenceWritableKeyPath<Target, RegisteredType>, key: Key<RegisteredType>, cached: Bool? = nil) -> Injector<Target> {
        return inject { (target, resolver) in
            guard let resolved = resolver.resolve(key: key, cached: cached) else { return target }
            target[keyPath: keyPath] = resolved
            return target
        }
    }
    
    /**
     Registers a non-optional `KeyPath` injection that is satisfied by the
     registration with the given `RegisteredType`, `name`, and `container`.
     
     ```
     .inject(exact: \.foo, container: Container.plugins)
     ```
     */
    public func inject<RegisteredType>(exact keyPath: ReferenceWritableKeyPath<Target, RegisteredType>, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Injector<Target> {
        return inject(exact: keyPath, key: Key<RegisteredType>(name: name, container: container), cached: cached)
    }
    
    /**
     Registers a `KeyPath` injection that is satisfied by the given `key`.
     
     ```
     .inject(\.api, key: Key(name: Name.api2))
     ```
     
     ```
     class MyAwesomeViewController {
         var api: Api?
         override func viewDidLoad() {
             super.viewDidLoad()
             Guise.resolve(into: self)
         }
     }
     ```
     
     - note: It's best to use the other, more convenient `inject` overloads.
     */
    public func inject<RegisteredType>(_ keyPath: WritableKeyPath<Target, RegisteredType?>, key: Key<RegisteredType>, cached: Bool? = nil) -> Injector<Target> {
        return inject { (target, resolver) in
            var target = target
            target[keyPath: keyPath] = resolver.resolve(key: key, cached: cached)
            return target
        }
    }
    
    /**
     Registers a `KeyPath` injection that is satisfied by the
     registration with the given `RegisteredType`, `name`, and `container`.
     
     ```
     .inject(\.foo, container: Container.plugins)
     ```
     */
    public func inject<RegisteredType>(_ keyPath: WritableKeyPath<Target, RegisteredType?>, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Injector<Target> {
        return inject(keyPath, key: Key<RegisteredType>(name: name, container: container), cached: cached)
    }
    
    
    /**
     Registers a `KeyPath` injection that is satisfied by the given `key`.
     
     ```
     .inject(\.api, key: Key(name: Name.api2))
     ```
     
     ```
     class MyAwesomeViewController {
        var api: Api?
        override func viewDidLoad() {
            super.viewDidLoad()
            Guise.resolve(into: self)
        }
     }
     ```
     
     - note: It's best to use the other, more convenient `inject` overloads.
     */
    public func inject<RegisteredType>(_ keyPath: ReferenceWritableKeyPath<Target, RegisteredType?>, key: Key<RegisteredType>, cached: Bool? = nil) -> Injector<Target> {
        return inject { (target, resolver) in
            target[keyPath: keyPath] = resolver.resolve(key: key, cached: cached)
            return target
        }
    }
    
    /**
     Registers a `KeyPath` injection that is satisfied by the
     registration with the given `RegisteredType`, `name`, and `container`.
     
     ```
     .inject(\.foo, container: Container.plugins)
     ```
     */
    public func inject<RegisteredType>(_ keyPath: ReferenceWritableKeyPath<Target, RegisteredType?>, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default, cached: Bool? = nil) -> Injector<Target> {
        return inject(keyPath, key: Key<RegisteredType>(name: name, container: container), cached: cached)
    }
    
    /**
     Registers any preceding injections with the resolver and returns the key
     under which the registrations were made.
     
     ```
     Guise.into(injectable: Foo.self).inject(\.bar).inject(\.baz).register()
     ```
     
     - note: This method **must** be called in order to finish registration.
     Without the call to `register` in the example above, the injections
     have no effect when `resolve(into:)` is called because the resolver
     does not know about them.
    */
    @discardableResult public func register() -> String {
        let injections = self.injections
        return resolver.register(injectable: Target.self) {
            var target = $0
            for injection in injections {
               target = injection(target, $1)
            }
            return target
        }
    }
}
