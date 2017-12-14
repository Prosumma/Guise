//
//  Registration.swift
//  Guise
//
//  Created by Gregory Higley on 9/3/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 A simple class to hold the resolution block
 and a few other interesting bits.
 */
class _Registration: Registration {
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
    public let metadata: Any
    public let isWeak: Bool
    
    init<P, T>(metadata: Any, cached: Bool, resolution: @escaping Resolution<P, T>) {
        self.isWeak = T.self is _Weak.Type
        self.metadata = metadata
        self.cached = isWeak || cached
        self.resolution = { param in resolution(param as! P) }
        self.cacheQueue = DispatchQueue(label: "com.prosumma.Guise.Registration.[\(String(reflecting: T.self))].\(UUID())")
    }
    
    /// - warning: An incompatible `T` will cause an unrecoverable runtime exception.
    public func resolve<T>(parameter: Any, cached: Bool?) -> T? {
        if isWeak {
            let result: Weak<T>
            if instance == nil {
                cacheQueue.sync {
                    if instance != nil { return }
                    instance = resolution(parameter)
                }
                result = instance! as! Weak<T>
            } else {
                result = resolution(parameter) as! Weak<T>
            }
            return result.value
        } else {
            let result: T
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
}
