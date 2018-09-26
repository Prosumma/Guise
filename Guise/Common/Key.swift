//
//  Key.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/// A type-safe `Keyed` implementation.
public struct Key<RegisteredType>: Keyed, Hashable {
    /// The registered type.
    public let type = String(reflecting: RegisteredType.self)
    /// The name under which the registration was made. Defaults to `Guise.Name.default`.
    public let name: AnyHashable
    /// The container in which the registration was made. Defaults to `Guise.Container.default`.
    public let container: AnyHashable
    
    public init(name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default) {
        self.name = name
        self.container = container
    }
    
    /**
     Converts another `Keyed` to `Key<RegisteredType>`. This
     initializer will fail if the `type` parameters are not
     identical, so care must be used when converting.
     
     ```
     if let key = Key<SomeType>(anotherKey) {
       // Do something with key
     }
     ```
     */
    public init?(_ key: Keyed) {
        self.init(name: key.name, container: key.container)
        if key.type != self.type { return nil }
    }
}


