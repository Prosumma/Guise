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
    /// If the Holder specifies caching, this will override all other caching
    let holderCached: Bool?
    /// Requested lifecycle for the dependency
    let cached: Bool
    /// The registered resolution block
    private let resolution: (Any) -> Any
    /// Gets the underlying value from the holder
    private let get: (Any) -> Any?
    /// Cached instance, if any
    private var instance: Any?
    /// Metadata, which defaults to an instance of `Void`, i.e., `()`
    public let metadata: Any
    
    init<P, H: Holder>(metadata: Any, cached: Bool, resolution: @escaping Resolution<P, H>) {
        self.metadata = metadata
        self.holderCached = H.cached
        self.cached = cached
        self.resolution = { param in resolution(param as! P) }
        self.get = { ($0 as! H).value }
        self.cacheQueue = DispatchQueue(label: "com.prosumma.Guise.Registration.[\(String(reflecting: H.Held.self))].\(UUID())")
    }
    
    /// - warning: An incompatible `T` will cause an unrecoverable runtime exception.
    public func resolve<T>(parameter: Any, cached: Bool?) -> T? {
        let result: T?
        if self.holderCached ?? cached ?? self.cached {
            if instance == nil {
                cacheQueue.sync {
                    if instance != nil { return }
                    instance = resolution(parameter)
                }
            }
            result = get(instance!) as! T?
        } else {
            result = get(resolution(parameter)) as! T?
        }
        return result
    }
}
