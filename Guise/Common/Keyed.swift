//
//  Keyed.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 The protocol which all keys must implement.
 
 Registrations are always made by key. A subsequent
 registration made under the same key silently
 overwrites a previous registration.
 
 A key records three facts about a registration: its type
 (as a `String`), name, and container. These facts are
 supplied at registration using either a key directly
 or one of the convenience overloads. `name` and `container`
 default to `Guise.Name.default` and `Guise.Container.default`
 respectively.
 
 A `Keyed` can be converted to another `Keyed` with the
 failable initializer supplied by this protocol. The
 initializer never fails in a type-erased `Keyed` implementation
 (i.e., `AnyKey`) but will fail for a type-safe `Keyed`
 implementation (i.e., `Key<RegisteredType>`) if the types
 are not compatible.
 */
public protocol Keyed {
    /// The registered type.
    var type: String { get }
    /// The name under which the registration was made. Defaults to `Guise.Name.default`.
    var name: AnyHashable { get }
    /// The container in which the registration was made. Defaults to `Guise.Container.default`.
    var container: AnyHashable { get }
    /**
     A `Keyed` can be converted to another `Keyed` with this
     failable initializer. The initializer never fails in a
     type-erased `Keyed` implementation (i.e., `AnyKey`) but
     will fail for a type-safe `Keyed` implementation (i.e.,
     `Key<RegisteredType>`) if the types are not compatible.
    */
    init?(_ key: Keyed)
}

public func ==(lhs: Keyed, rhs: Keyed) -> Bool {
    return lhs.type == rhs.type && lhs.name == rhs.name && lhs.container == rhs.container
}

public func ==<K: Keyed>(lhs: K, rhs: K) -> Bool {
    return lhs.type == rhs.type && lhs.name == rhs.name && lhs.container == rhs.container
}
