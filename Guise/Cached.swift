//
//  Cached.swift
//  Guise
//
//  Created by Gregory Higley on 12/15/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/// Cached `Holder`. This type forces caching.
public struct Cached<T>: Holder {
    public let value: T?
    public init(_ value: T) {
        self.value = value
    }
    public static var cached: Bool? {
        return true
    }
}
