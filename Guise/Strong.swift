//
//  Strong.swift
//  Guise
//
//  Created by Gregory Higley on 12/15/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 `Strong` is the default `Holder`.
 
 `Strong` holds a strong reference to a value and simply
 regurgitates it. Can be cached or not.
 */
public struct Strong<T>: Holder {
    public let value: T?
    
    public init(_ value: T) {
        self.value = value
    }
}
