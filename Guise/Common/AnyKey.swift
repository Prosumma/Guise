//
//  AnyKey.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/// A type-erased `Keyed` implementation.
public struct AnyKey: Keyed, Hashable {
    /// The registered type.
    public let type: String
    /// The name under which the registration was made. Defaults to `Guise.Name.default`.
    public let name: AnyHashable
    /// The container in which the registration was made. Defaults to `Guise.Container.default`.
    public let container: AnyHashable
    
    public init<T>(type: T.Type, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default) {
        self.type = String(reflecting: type)
        self.name = name
        self.container = container
    }
    
    /**
     Converts another `Keyed` to `AnyKey`. This initializer
     is failable because it inherits from the `Keyed` protocol.
     However, in the case of `AnyKey`, it can never fail, so it
     is always safe (and always recommended) to force-unwrap
     the result of this initializer.
     
     ```
     let key = AnyKey(anotherKey)!
     ```
    */
    public init?(_ key: Keyed) {
        self.type = key.type
        self.name = key.name
        self.container = key.container
    }
}
