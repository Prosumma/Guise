//
//  Injector.swift
//  Guise
//
//  Created by Gregory Higley on 12/12/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public struct Injector<Target> {
    let resolver: Guising
    var injections = [Injection<Target>]()
    
    public init(resolver: Guising) {
        self.resolver = resolver
    }

    public func inject(injection: @escaping Injection<Target>) -> Injector<Target> {
        var injector = self
        injector.injections.append(injection)
        return injector
    }
    
    public func inject<Value>(_ keyPath: WritableKeyPath<Target, Value?>, key: Key<Value>) -> Injector<Target> {
        return inject { (target, resolver) in
            var target = target
            target[keyPath: keyPath] = resolver.resolve(key: key)
            return target
        }
    }
    
    public func inject<Value>(_ keyPath: WritableKeyPath<Target, Value?>, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default) -> Injector<Target> {
        return inject(keyPath, key: Key(name: name, container: container))
    }
    
    public func inject<Value>(_ keyPath: ReferenceWritableKeyPath<Target, Value?>, key: Key<Value>) -> Injector<Target> {
        return inject { (target, resolver) in
            target[keyPath: keyPath] = resolver.resolve(key: key)
            return target
        }
    }
    
    public func inject<Value>(_ keyPath: ReferenceWritableKeyPath<Target, Value?>, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default) -> Injector<Target> {
        return inject(keyPath, key: Key(name: name, container: container))
    }
    
    @discardableResult public func register() -> Key<Target> {
        let injections = self.injections
        return resolver.register(injectable: Target.self) { (target, resolver) in
            var target = target
            for injection in injections {
                target = injection(target, resolver)
            }
            return target
        }
    }
}
