//
//  Inject.swift
//  Guise
//
//  Created by Gregory Higley on 2/11/18.
//  Copyright © 2018 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolving {
    
    /**
     Registers a typed injection.
     
     A typed injection is a block that takes two parameters. The first
     is the target of the injection, and the second is the resolver
     with which the injection is registered. The injection's key is
     the fully qualified name of the target type as determined by
     `String(reflecting:)`.
     
     ```
     Guise.register(injectable: AwesomeViewController.self) {
        (target, resolver) in
        target.dependency = resolver.resolve()
        return target
     }
     ```
     
     The resolver can be used to resolve any dependencies of the target.
     
     In a typed injection, validating that the injection is applicable to
     a particular target during resolution is handled for you.
     
     - note: This overload is strongly recommended over using the "root"
     overload which takes a `String` and a injection of type `Injection<Any>`.
     */
    @discardableResult func register<Injectable>(injectable type: Injectable.Type, injection: @escaping Injection<Injectable>) -> String {
        let injectable = String(reflecting: type)
        return register(injectable: injectable) {
            guard let target = $0 as? Injectable else {
                return $0
            }
            return injection(target, $1)
        }
    }
    
    /**
     Unregisters the injection registered under the given type.
     
     - parameter type: The type whose injection should be unregistered.
     - returns: `true` if the injection was found and unregistered, otherwise `false`.
     */
    @discardableResult func unregister<Injectable>(injectable type: Injectable.Type) -> Bool {
        let key = String(reflecting: type)
        return unregister(injectables: [key]) == 1
    }
    
    /**
     Starts the registration of one or more `KeyPath` injections into
     the target type. Almost all injection should be done in this way.
     
     ```
     class MyAwesomeViewController: ViewController {
     
         var api: Api!
         var logger: XCGLogger?
     
         override func viewDidLoad() {
            super.viewDidLoad()
            Guise.resolve(into: self)
         }
     
     }

     // Register our dependencies
     Guise.register(instance: Api(), name: Name.api)
     Guise.register(instance: XCGLogger.default)
     
     // Register our injections
     Guise.into(injectable: MyAwesomeViewController.self)
        .inject(\.api, name: Name.api)
        .inject(\.logger)
        .register()
     ```
     
     Our awesome view controller has two dependencies: `api` and `logger`.
     In order to resolve a dependency, it must first be registered with Guise,
     so we register an `Api` instance and an `XCGLogger` instance.
     
     We then register our injections. `Guise.into(injectable: MyAwesomeViewController.self)`
     tells Guise that we are going to register injections into this type. `.inject(\.api, name: Name.api)`
     tells Guise that in order to hydrate the `api` property of `MyAwesomeViewController`,
     we need an instance of `Api` registered under the name `Name.api`. (The fact that we
     need an instance of `Api` is implicit. The `KeyPath` `MyAwesomeViewController.api` is
     of type `KeyPath<MyAwesomeViewController, ImplicitlyUnwrappedOptional<Api>>`. This tells
     Guise what it needs to know, so the type does not need to be mentioned.) Similarly,
     `.inject(\.logger)` tells Guise that to hydrate the `logger` property of `MyAwesomeViewController`
     we need an instance of `XCGLogger`. Guise knows the types involved because Swift keypaths are
     typesafe.
     
     When `Guise.resolve(into: self)` is called, the dependencies are hydrated.
     */
    func into<Target>(injectable type: Target.Type) -> Injector<Target> {
        return Injector(resolver: self)
    }
}

public extension _Guise {
    @discardableResult static func register<Injectable>(injectable: Injectable.Type, injection: @escaping Injection<Injectable>) -> String {
        return resolver.register(injectable: injectable, injection: injection)
    }
    
    @discardableResult static func unregister<Injectable>(injectable: Injectable.Type) -> Bool {
        return resolver.unregister(injectable: injectable)
    }
    
    static func into<Target>(injectable type: Target.Type) -> Injector<Target> {
        return resolver.into(injectable: type)
    }
}
