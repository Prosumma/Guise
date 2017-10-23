//
//  Registration.swift
//  Guise
//
//  Created by Gregory Higley on 9/3/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 The type of a resolution block.
 
 Guise does not register types or instances directly.
 Instead, it registers resolution blocks, which have
 the type given below.
 
 In most cases, the type of `P` is `Void`, i.e., no
 argument at all, e.g.,
 
 ```
 Guise.register{ SomeDependency() as SomeAbstraction }
 ```
 */
public typealias Resolution<P, T> = (P) -> T

/**
 A simple class to hold the resolution block
 and a few other interesting bits.
 */
class Registration {
    /**
     A private serial dispatch queue for cache resolution.
     
     This just ensures that we don't resolve more than once
     due to concurrency when creating a cached value.
     */
    private let cacheQueue: DispatchQueue
    /// Default lifecycle for the dependency
    let cached: Bool
    /// The registered resolution block
    private let resolution: (Any) -> Any
    /// Cached instance, if any
    private var instance: Any?
    /// Metadata, which defaults to an instance of `Void`, i.e., `()`
    let metadata: Any
    
    init<P, T>(metadata: Any, cached: Bool, resolution: @escaping Resolution<P, T>) {
        self.metadata = metadata
        self.cached = cached
        self.resolution = { param in resolution(param as! P) }
        self.cacheQueue = DispatchQueue(label: "com.prosumma.Guise.Registration.[\(String(reflecting: T.self))].\(UUID())")
    }
    
    /// - warning: An incompatible `T` will cause an unrecoverable runtime exception.
    func resolve<T>(parameter: Any, cached: Bool?) -> T {
        var result: T
        if cached ?? self.cached {
            if instance == nil {
                cacheQueue.sync {
                    if instance != nil { return }
                    instance = resolution(parameter)
                }
            }
            result = instance! as! T
        } else {
            result = resolution(parameter) as! T
        }
        return result
    }
}
