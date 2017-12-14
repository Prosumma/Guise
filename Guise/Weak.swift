//
//  Weak.swift
//  Guise
//
//  Created by Gregory Higley on 11/22/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public protocol _Weak {}

// Adapted from https://stackoverflow.com/a/47441469/27779
/**
 A `weak` container for reference types.
 
 - warning: If you pass a value type to `Weak`, its `value`
 property will always return `nil` due to boxing.
 */
public struct Weak<T>: _Weak {
    private weak var ref: AnyObject?

    /**
     Initalizes a `weak` container for reference types.
     
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
}

