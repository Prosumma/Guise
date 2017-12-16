//
//  Weak.swift
//  Guise
//
//  Created by Gregory Higley on 11/22/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

// Adapted from https://stackoverflow.com/a/47441469/27779
/**
 A `weak` `Holder` for reference types.
 
 - warning: If you pass a value type to `Weak`, its `value`
 property will always return `nil` due to boxing.
 */
public struct Weak<T>: Holder {
    private weak var ref: AnyObject?

    /**
     Initalizes a `weak` `Holder` for reference types.
     
     - warning: If you pass a value type to `Weak`, its `value`
     property will always return `nil` due to boxing.
     */
    public init(_ value: T) {
        ref = value as AnyObject
    }

    /// Returns the stored value or `nil` if the `weak` reference has been reaped.
    public var value: T? {
        return ref as! T?
    }
    
    public static var cached: Bool? {
        return true
    }
}

