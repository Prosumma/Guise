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
    private let value: (Any) -> Any?
    /// Cached holder, if any
    private var holder: Any?
    /// Metadata, which defaults to an instance of `Void`, i.e., `()`
    public let metadata: Any
    /// Whether `ParameterType` is `Guising`
    public let expectsResolver: Bool
    
    init<ParameterType, HoldingType: Holder>(metadata: Any, cached: Bool, resolution: @escaping Resolution<ParameterType, HoldingType>) {
        self.expectsResolver = ParameterType.self is Guising.Type
        self.metadata = metadata
        self.holderCached = HoldingType.cached
        self.cached = cached
        self.resolution = { param in resolution(param as! ParameterType) }
        self.value = { ($0 as! HoldingType).value }
        self.cacheQueue = DispatchQueue(label: "\(UUID())")
    }
    
    /// - warning: An incompatible `T` will cause an unrecoverable runtime exception.
    public func resolve<RegisteredType>(parameter: Any, cached: Bool?) -> RegisteredType? {
        let result: RegisteredType?
        if self.holderCached ?? cached ?? self.cached {
            if holder == nil {
                cacheQueue.sync {
                    if holder != nil { return }
                    holder = resolution(parameter)
                }
            }
            result = value(holder!) as! RegisteredType?
        } else {
            result = value(resolution(parameter)) as! RegisteredType?
        }
        return result
    }
}
