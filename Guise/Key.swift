//
//  Key.swift
//  Guise
//
//  Created by Gregory Higley on 9/3/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 Any type that implements this protocol and is also `Hashable`
 can serve as a key in Guise.

 A key unambiguously identifies a registration. If a registration
 uses or produces the same key, it is the _same_ registration. This
 means that if `register` is called with the same (implicit) key,
 it will overwrite any previous registration.
 
 While it is theoretically possible to create a custom key, in
 practice the two key types `AnyKey` and `Key<T>` will always
 suffice. The former is type-erased while the latter is type-safe.
 */
public protocol Keyed {
    /// The registered type
    var type: String { get }
    /// The registered name, which defaults to `Guise.Name.default`
    var name: AnyHashable { get }
    /// The registered container, which defaults to `Guise.Container.default`
    var container: AnyHashable { get }
    /// Failable initializer to convert from one `Keyed` to another.
    init?(_ key: Keyed)
}

public func ==<K: Keyed & Hashable>(lhs: K, rhs: K) -> Bool {
    if lhs.hashValue != rhs.hashValue { return false }
    if lhs.type != rhs.type { return false }
    if lhs.name != rhs.name { return false }
    if lhs.container != rhs.container { return false }
    return true
}

public struct AnyKey: Keyed, Hashable {
    /// The registered type
    public let type: String
    /// The registered name, which defaults to `Guise.Name.default`
    public let name: AnyHashable
    /// The registered container, which defaults to `Guise.Container.default`
    public let container: AnyHashable
    /// The hashValue required by `Hashable`
    public let hashValue: Int
    
    private init(type: String, name: AnyHashable, container: AnyHashable) {
        self.type = type
        self.name = name
        self.container = container
        self.hashValue = hash(self.type, self.name, self.container)
    }
    
    /**
     Failable initializer to convert from one `Keyed` to another.
     
     This initializer is required by the `Keyed` protocol. In the case of
     `AnyKey`, it can never fail, so it is safe to force-unwrap the result.
     
     - parameter key: The key to convert to `AnyKey`
     */
    public init?(_ key: Keyed) {
        self.init(type: key.type, name: key.name, container: key.container)
    }
    
    /// Initialize `AnyKey` in a type-safe manner.
    public init<T>(type: T.Type, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default) {
        self.init(type: String(reflecting: type), name: name, container: container)
    }
}

/**
 Typesafe key.
 */
public struct Key<T>: Keyed, Hashable {
    /// The registered type
    public let type: String
    /// The registered name, which defaults to `Guise.Name.default`
    public let name: AnyHashable
    /// The registered container, which defaults to `Guise.Container.default`
    public let container: AnyHashable
    /// The hashValue required by `Hashable`
    public let hashValue: Int

    private init(type: T.Type, name: AnyHashable, container: AnyHashable) {
        self.type = String(reflecting: type)
        self.name = name
        self.container = container
        self.hashValue = hash(self.type, self.name, self.container)
    }
    
    /**
     Failable initializer from the `Keyed` protocol, used to convert a `Keyed` into a `Key<T>`.
     
     This initializer will fail if `key.type` is not identical to `String(reflecting: T.self)`.
     */
    public init?(_ key: Keyed) {
        if key.type != String(reflecting: T.self) { return nil }
        self.init(type: T.self, name: key.name, container: key.container)
    }

    /// Creates a new `Key<T>` using the specified `name` and `container`.
    public init(name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default) {
        self.init(type: T.self, name: name, container: container)
    }
}
