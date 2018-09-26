//
//  Holder.swift
//  Guise
//
//  Created by Gregory Higley on 12/15/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 A `Holder` holds a value and optionally
 provides caching semantics. Guise requires
 a `Holder` to be the return value of a
 registration block. If a `Holder` is not
 explicitly provided, the `Strong` holder
 will be used implicitly.
 
 The `Held` associated type is the type
 of the value held. Practically speaking,
 this means it is always the registered type.
 
 When a cached registration is made, it is
 actually the holder that is cached, not an
 instance of the underlying registered type.
 
 There are four implementations of `Holder`
 in Guise: `Strong` (the default), `Weak`,
 `Cached` and `Uncached`. See their documentation.
 */
public protocol Holder {
    
    /// The type of the value held.
    associatedtype Held
    
    /**
     Gets the value held. Returns `nil`
     only for the `Weak` holder.
    */
    var value: Held? { get }
    
    /**
     Desired caching semantics. If this
     method returns `nil`, caching semantics
     will be provided at registration by the `cached`
     parameter. If it returns any other value,
     the `cached` parameter of the `register` overloads
     will be ignored and this value will be used.
    */
    static var cached: Bool? { get }
}

public extension Holder {
    
    /// By default, holders do not specify caching semantics.
    static var cached: Bool? {
        return nil
    }
}
