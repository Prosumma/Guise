/*
The MIT License (MIT)

Copyright (c) 2016 - 2017 Gregory Higley (Prosumma)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import Foundation

// MARK: -

/// `Name.default` is used for the default name of a container or type when one is not specified.
public enum Name {
    /// `Name.default` is used for the default name of a container or type when one is not specified.
    case `default`
}

// MARK: - Keys

/**
 The protocol shared by `Key<T>` and `AnyKey`.

 Registration in Guise associates a unique `Keyed` with
 a dependency. Any registration using the same `Keyed`
 overwrites any previous registration.
 
 A `Keyed` consists of a `type`, `name`, and `container`.
 The only truly required attribute is `type`. While the
 others cannot be `nil`, they can be defaulted to `Name.default`.
 Any `Hashable` value can be used for `name` and `container`.
 All three of these attributes together are what make a `Keyed`
 unique.
 */
public protocol Keyed {
    /// The fully qualified name of a type produced by `String(reflecting: type)`.
    var type: String { get }
    
    /**
     The name of a registration. Defaults to `Name.default`.
     
     Names can be used to disambiguate registrations of the same type.
    */
    var name: AnyHashable { get }
    
    /**
     The container of a registration. Defaults to `Name.default`.
     
     A container may be used to group registrations together for
     any purpose. One common use is to quickly _unregister_ many
     registrations at once:
     
         Guise.unregister(container: Container.plugins)
    */
    var container: AnyHashable { get }

    /// Convert from one `Keyed` implementation to another.
    init?(_ key: Keyed)
    
    /// Create a `Keyed`.
    init?<T, N: Hashable, C: Hashable>(type: T.Type, name: N, container: C)
}

public func ==<K: Keyed & Hashable>(lhs: K, rhs: K) -> Bool {
    if lhs.hashValue != rhs.hashValue { return false }
    if lhs.type != rhs.type { return false }
    if lhs.name != rhs.name { return false }
    if lhs.container != rhs.container { return false }
    return true
}

/**
 A type-erasing unique key under which to register a block in Guise.
 
 This type is used primarily when keys must be stored heterogeneously,
 e.g., in `Set<AnyKey>` returned from a `filter` overload.
 
 This is also the type that Guise uses under the hood to associate
 keys with registered dependencies.
 
 - note: See the documentation of the `Keyed` protocol for a fuller
 discussion of keys.
*/
public struct AnyKey: Keyed, Hashable {
    public let type: String
    public let name: AnyHashable
    public let container: AnyHashable
    public let hashValue: Int
    
    private init(type: String, name: AnyHashable, container: AnyHashable) {
        self.type = type
        self.name = name
        self.container = container
        self.hashValue = hash(self.type, self.name, self.container)
    }
    
    /**
     Create an `AnyKey` from a `Keyed`.
     
     This initializer is failable due to conformance with `Keyed`.
     However, in the case of `AnyKey` it will never fail. When
     using this initializer it is safe to force-unwrap the result, e.g.,
     
     ```
     let key = AnyKey(otherKey)!
     ```
    */
    public init?(_ key: Keyed) {
        self.init(type: key.type, name: key.name, container: key.container)
    }

    /**
     Create an `AnyKey` from the given parameters.
     
     This initializer is failable due to conformance with `Keyed`.
     However, in the case of `AnyKey` it will never fail. When
     using this initializer it is safe to force-unwrap the result, e.g.,
     
     ```
     let key = AnyKey(type: String.self, name: Name.default, container: Name.default)!
     ```
    */
    public init?<T, N: Hashable, C: Hashable>(type: T.Type, name: N, container: C) {
        self.init(type: String(reflecting: T.self), name: name, container: container)
    }
    
    public init<T, N: Hashable>(type: T.Type, name: N) {
        self.init(type: String(reflecting: T.self), name: name, container: Name.default)
    }

    public init<T, C: Hashable>(type: T.Type, container: C) {
        self.init(type: String(reflecting: T.self), name: Name.default, container: container)
    }

    public init<T>(type: T.Type) {
        self.init(type: String(reflecting: T.self), name: Name.default, container: Name.default)
    }
}

/**
 A type-safe registration key.
 
 This type is used wherever type-safety is needed or
 wherever keys are requested by type.
 
 - note: See the documentation of the `Keyed` protocol for a fuller
 discussion of keys.
 */
public struct Key<T>: Keyed, Hashable {
    public let type: String
    public let name: AnyHashable
    public let container: AnyHashable
    public let hashValue: Int
    
    private init(type: String, name: AnyHashable, container: AnyHashable) {
        self.type = type
        self.name = name
        self.container = container
        self.hashValue = hash(self.type, self.name, self.container)
    }
    
    /**
     Create a `Key<T>` from a `Keyed`.
     
     If the underlying type stored in `key` is incompatible with the
     generic type parameter `T`, this initializer will fail.
     
     ```
     let key1 = Key<String>()
     let key2 = Key<Int>(key1)
     ```
     
     The second assignment fails because `key1` stores the type `String`,
     which is not the same as the generic type parameter `T` of `key2`,
     which in this case is `Int`.
     
     - note: Required by the `Keyed` protocol.
    */
    public init?(_ key: Keyed) {
        if key.type != String(reflecting: T.self) { return nil }
        self.init(type: key.type, name: key.name, container: key.container)
    }
    
    /**
     Create a `Key<T>` from a `Keyed`.
     
     If the type of `O` is not exactly the same as the type `T`, this
     initializer will fail.
     
     ```
     let key = Key<Int>(type: String.self, name: Name.default, container: Name.default)
     ```
     
     Because `String` and `Int` are not the same type, this initializer will fail.
     
     - note: Required by the `Keyed` protocol.
    */
    public init?<O, N: Hashable, C: Hashable>(type: O.Type, name: N, container: C) {
        guard O.self == T.self else { return nil }
        self.init(type: String(reflecting: T.self), name: name, container: container)
    }
    
    public init<N: Hashable, C: Hashable>(name: N, container: C) {
        self.init(type: String(reflecting: T.self), name: name, container: container)
    }
    
    public init<N: Hashable>(name: N) {
        self.init(name: name, container: Name.default)
    }
    
    public init<C: Hashable>(container: C) {
        self.init(name: Name.default, container: container)
    }
    
    public init() {
        self.init(name: Name.default, container: Name.default)
    }
    
}

// MARK: -

/**
 This class creates and holds a type-erasing thunk over a registration block.
 
 Guise creates a mapping between a `Keyed` and a `Dependency`. `Keyed` holds
 the `type`, `name`, and `container`, while `Dependency` holds the resolution
 block, metadata, caching preference, and any cached instance.
 */
private class Dependency {
    /** Default lifecycle for the dependency. */
    let cached: Bool
    /** Registered block. */
    private let resolution: (Any) -> Any
    /** Cached instance, if any. */
    private var instance: Any?
    /** Metadata */
    let metadata: Any
    
    init<P, T>(metadata: Any, cached: Bool, resolution: @escaping Resolution<P, T>) {
        self.metadata = metadata
        self.cached = cached
        self.resolution = { param in resolution(param as! P) }
    }
    
    func resolve<T>(parameter: Any, cached: Bool?) -> T {
        var result: T
        if cached ?? self.cached {
            if instance == nil {
                instance = resolution(parameter)
            }
            result = instance! as! T
        } else {
            result = resolution(parameter) as! T
        }
        return result
    }
}

// MARK: -

/**
 The type of a resolution block.
 
 These are what actually get registered. Guise does not register
 types or instances directly.
 */
public typealias Resolution<P, T> = (P) -> T

/**
 The type of a metadata filter.
 */
public typealias Metafilter<M> = (M) -> Bool

/**
 Used in filters.
 
 This type exists primarily to emphasize that the `metathunk` method should be applied to
 `Metafilter<M>` before the metafilter is passed to the master `filter` or `exists` method.
 */
private typealias Metathunk = Metafilter<Any>

/**
 Guise is a simple dependency resolution framework.
 
 Guise does not register types or instances directly. Instead,
 it registers a resolution block which returns the needed dependency.
 Guise manages a thread-safe dictionary mapping keys to resolution 
 blocks.

 The key with which each dependency is associated consists of the
 return type of the resolution block, a `Hashable` name, and a `Hashable`
 container. The name and container default to `Name.default`, so
 they do not need to be specified unless required.
 
 In addition, it is common to alias the return type of the resolution
 block using a protocol to achieve abstraction.
 
 This simple, flexible system can accommodate many scenarios. Some of 
 these scenarios are so common that overloads exist to handle them
 concisely.
 
 - note: Instances of this type cannot be created. Use its static methods.
 */
public struct Guise {
    private init() {}
    
    private static var lock = Lock()
    private static var registrations = [AnyKey: Dependency]()
    
    /**
     All keys.
     */
    public static var keys: Set<AnyKey> {
        return lock.read { Set(registrations.keys) }
    }
    
    // MARK: Registration
    
    /**
     Register the `resolution` block with the result type `T` and the parameter `P`.
     
     - returns: The `key` that was passed in.
     
     - parameters:
         - key: The `Key` under which to register the block.
         - metadata: Arbitrary metadata associated with this registration.
         - cached: Whether or not to cache the result of the registration block.
         - resolution: The block to register with Guise.
    */
    public static func register<P, T>(key: Key<T>, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<P, T>) -> Key<T> {
        lock.write { registrations[AnyKey(key)!] = Dependency(metadata: metadata, cached: cached, resolution: resolution) }
        return key
    }
    
    /**
     Multiply register the `resolution` block with the result type `T` and the parameter `P`.
     
     - returns: The passed-in `keys`.
     
     - parameters:
         - keys: The keys under which to register the block.
         - metadata: Arbitrary metadata associated with this registration.
         - cached: Whether or not to cache the result of the registration block.
         - resolution: The block to register with Guise.
    */
    public static func register<P, T>(keys: Set<Key<T>>, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<P, T>) -> Set<Key<T>> {
        return lock.write {
            for key in keys {
                registrations[AnyKey(key)!] = Dependency(metadata: metadata, cached: cached, resolution: resolution)
            }
            return keys
        }
    }
    
    /**
     Register the `resolution` block with the result type `T` and the parameter `P`.
     
     - returns: The unique `Key<T>` for this registration.
     
     - parameters:
        - name: The name under which to register the block.
        - container: The container in which to register the block.
        - metadata: Arbitrary metadata associated with this registration.
        - cached: Whether or not to cache the result of the registration block after first use.
        - resolution: The block to register with Guise.
    */
    public static func register<P, T, N: Hashable, C: Hashable>(name: N, container: C, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<P, T>) -> Key<T> {
        return register(key: Key(name: name, container: container), metadata: metadata, cached: cached, resolution: resolution)
    }
    
    /**
     Register the `resolution` block with the result type `T` and the parameter `P`.
     
     - returns: The unique `Key<T>` for this registration.
     
     - parameters:
         - name: The name under which to register the block.
         - metadata: Arbitrary metadata associated with this registration.
         - cached: Whether or not to cache the result of the registration block.
         - resolution: The block to register with Guise.
     
     - note: The registration is made in the default container, `Name.default`.
     */
    public static func register<P, T, N: Hashable>(name: N, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<P, T>) -> Key<T> {
        return register(key: Key(name: name, container: Name.default), metadata: metadata, cached: cached, resolution: resolution)
    }
    
    /**
     Register the `resolution` block with the result type `T` and the parameter `P`.
     
     - returns: The unique `Key<T>` for this registration.
     
     - parameters:
         - container: The container in which to register the block.
         - metadata: Arbitrary metadata associated with this registration.
         - cached: Whether or not to cache the result of the registration block.
         - resolution: The block to register with Guise.
     
     - note: The registration is made with the default name, `Name.default`.
     */
    public static func register<P, T, C: Hashable>(container: C, metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<P, T>) -> Key<T> {
        return register(key: Key(name: Name.default, container: container), metadata: metadata, cached: cached, resolution: resolution)
    }
    
    /**
     Register the `resolution` block with the result type `T` and the parameter `P`.
     
     - returns: The unique `Key<T>` for this registration.
     
     - parameters:
         - metadata: Arbitrary metadata associated with this registration.
         - cached: Whether or not to cache the result of the registration block.
         - resolution: The block to register with Guise.
     
     - note: The registration is made in the default container, `Name.default` and under the default name, `Name.default`.
    */
    public static func register<P, T>(metadata: Any = (), cached: Bool = false, resolution: @escaping Resolution<P, T>) -> Key<T> {
        return register(key: Key(name: Name.default, container: Name.default), metadata: metadata, cached: cached, resolution: resolution)
    }
    
    /**
     Register an instance.
     
     - returns: The unique `Key<T>` for this registration.
     
     - parameters:
        - instance: The instance to register.
        - name: The name under which to register the block.
        - container: The container in which to register the block.
        - metadata: Arbitrary metadata associated with this registration.
    */
    public static func register<T, N: Hashable, C: Hashable>(instance: T, name: N, container: C, metadata: Any = ()) -> Key<T> {
        return register(key: Key(name: name, container: container), metadata: metadata, cached: true) { instance }
    }
    
    /**
     Register an instance.
     
     - returns: The unique `Key<T>` for this registration.
     
     - parameters:
         - instance: The instance to register.
         - name: The name under which to register the block.
         - metadata: Arbitrary metadata associated with this registration.
     
     - note: The registration is made in the default container, `Name.default`.
    */
    public static func register<T, N: Hashable>(instance: T, name: N, metadata: Any = ()) -> Key<T> {
        return register(key: Key(name: name, container: Name.default), metadata: metadata, cached: true) { instance }
    }
    
    /**
     Register an instance.
     
     - returns: The unique `Key<T>` for this registration.
     
     - parameters:
         - instance: The instance to register.
         - container: The container in which to register the block.
         - metadata: Arbitrary metadata associated with this registration.
     
     - note: The registration is made with the default name, `Name.default`.
    */
    public static func register<T, C: Hashable>(instance: T, container: C, metadata: Any = ()) -> Key<T> {
        return register(key: Key(name: Name.default, container: container), metadata: metadata, cached: true) { instance }
    }
    
    /**
     Register an instance.
     
     - returns: The unique `Key<T>` for this registration.
     
     - parameters:
         - instance: The instance to register.
         - metadata: Arbitrary metadata associated with this registration.
     
     - note: The registration is made with the default name, `Name.default`, and in the default container, `Name.default`.
     */
    public static func register<T>(instance: T, metadata: Any = ()) -> Key<T> {
        return register(key: Key(name: Name.default, container: Name.default), metadata: metadata, cached: true) { instance }
    }
    
    // MARK: Resolution
    
    /**
     Resolve a dependency registered with `key`.
     
     - returns: The resolved dependency or `nil` if it is not found.
     
     - parameters:
        - key: The key to resolve.
        - parameter: A parameter to pass to the resolution block.
        - cached: Whether to use the cached value or to call the block again.
     
     - note: Passing `nil` for the `cached` parameter causes Guise to use the value of `cached` recorded
     when the dependency was registered. In most cases, this is what you want.
    */
    public static func resolve<T>(key: Key<T>, parameter: Any = (), cached: Bool? = nil) -> T? {
        guard let dependency = lock.read({ registrations[AnyKey(key)!] }) else { return nil }
        return dependency.resolve(parameter: parameter, cached: cached)
    }
    
    /**
     Resolve multiple registrations at the same time.
     
     - returns: An array of the resolved dependencies.
     
     - parameters:
        - keys: The keys to resolve.
        - parameter: A parameter to pass to the resolution block.
        - cached: Whether to use the cached value or to call the resolution block again.
     
     - note: Passing `nil` for the `cached` parameter causes Guise to use the value of `cached` recorded
     when the dependency was registered. In most cases, this is what you want.
    */
    public static func resolve<T>(keys: Set<Key<T>>, parameter: Any = (), cached: Bool? = nil) -> [T] {
        let dependencies: [Dependency] = lock.read {
            var dependencies = [Dependency]()
            for (key, dependency) in registrations {
                guard let key = Key<T>(key) else { continue }
                if !keys.contains(key) { continue }
                dependencies.append(dependency)
            }
            return dependencies
        }
        return dependencies.map{ $0.resolve(parameter: parameter, cached: cached) }
    }
    
    /**
     Resolve multiple registrations at the same time.
     
     - returns: A dictionary mapping each supplied `Key` to its resolved dependency of type `T`.
     
     - parameters:
         - keys: The keys to resolve.
         - parameter: A parameter to pass to the resolution block.
         - cached: Whether to use the cached value or to call the resolution block again.
     
;     - note: Passing `nil` for the `cached` parameter causes Guise to use the value of `cached` recorded
     when the dependency was registered. In most cases, this is what you want.
    */
    public static func resolve<T>(keys: Set<Key<T>>, parameter: Any = (), cached: Bool? = nil) -> [Key<T>: T] {
        let dependencies: Dictionary<Key<T>, Dependency> = lock.read {
            var dependencies = Dictionary<Key<T>, Dependency>()
            for (key, dependency) in registrations {
                guard let key = Key<T>(key) else { continue }
                if !keys.contains(key) { continue }
                dependencies[key] = dependency
            }
            return dependencies
        }
        return dependencies.map{ (key: $0.key, value: $0.value.resolve(parameter: parameter, cached: cached)) }.dictionary()
    }
    
    /**
     Resolve a dependency registered with the given key.
     
     - returns: The resolved dependency or `nil` if it is not found.
     
     - parameters:
         - name: The name under which the block was registered.
         - container: The container in which the block was registered.
         - parameter: A parameter to pass to the resolution block.
         - cached: Whether to use the cached value or to call the block again.
     
     Passing `nil` for the `cached` parameter causes Guise to use the value of `cached` recorded
     when the dependency was registered. In most cases, this is what you want.
    */
    public static func resolve<T, N: Hashable, C: Hashable>(name: N, container: C, parameter: Any = (), cached: Bool? = nil) -> T? {
        return resolve(key: Key(name: name, container: container), parameter: parameter, cached: cached)
    }
    
    /**
     Resolve a dependency registered with the given type `T` and `name`.
     
     - returns: The resolved dependency or `nil` if it is not found.
     
     - parameters:
         - name: The name under which the block was registered.
         - parameter: A parameter to pass to the resolution block.
         - cached: Whether to use the cached value or to call the block again.
     
     Passing `nil` for the `cached` parameter causes Guise to use the value of `cached` recorded
     when the dependency was registered. In most cases, this is what you want.
    */
    public static func resolve<T, N: Hashable>(name: N, parameter: Any = (), cached: Bool? = nil) -> T? {
        return resolve(key: Key(name: name, container: Name.default), parameter: parameter, cached: cached)
    }

    /**
     Resolve a dependency registered with the given type `T` in the given `container`.
     
     - returns: The resolved dependency or `nil` if it is not found.
     
     - parameters:
         - container: The container in which the block was registered.
         - parameter: A parameter to pass to the resolution block.
         - cached: Whether to use the cached value or to call the block again.
     
     Passing `nil` for the `cached` parameter causes Guise to use the value of `cached` recorded
     when the dependency was registered. In most cases, this is what you want.
    */
    public static func resolve<T, C: Hashable>(container: C, parameter: Any = (), cached: Bool? = nil) -> T? {
        return resolve(key: Key(name: Name.default, container: container), parameter: parameter, cached: cached)
    }

    /**
     Resolve a registered dependency.
     
     - returns: The resolved dependency or `nil` if it is not found.
     
     - parameters:
         - parameter: A parameter to pass to the resolution block.
         - cached: Whether to use the cached value or to call the block again.
     
     Passing `nil` for the `cached` parameter causes Guise to use the value of `cached` recorded
     when the dependency was registered. In most cases, this is what you want.
    */
    public static func resolve<T>(parameter: Any = (), cached: Bool? = nil) -> T? {
        return resolve(key: Key(name: Name.default, container: Name.default), parameter: parameter, cached: cached)
    }
    
    // MARK: Key Filtering
    
    /**
     Provides a thunk between `Metafilter<M>` and `Metafilter<Any>`.
     
     Checks to make sure that the metadata being checked actually is of type `M`.
    */
    private static func metathunk<M>(_ metafilter: @escaping Metafilter<M>) -> Metathunk {
        return {
            guard let metadata = $0 as? M else { return false }
            return metafilter(metadata)
        }
    }
    
    // The root filter method. All filters and existence checks ultimately end up here.
    private static func filter<K: Keyed & Hashable>(type: String?, name: AnyHashable?, container: AnyHashable?, metathunk: Metathunk? = nil) -> Set<K> {
        // Key matching is performed inside the lock (of course).
        let filtered: [K: Dependency] = lock.read {
            var filtered = Dictionary<K, Dependency>()
            for (key, dependency) in registrations {
                guard let key = K(key) else { continue }
                if let type = type, type != key.type { continue }
                if let name = name, name != key.name { continue }
                if let container = container, container != key.container { continue }
                filtered[key] = dependency
            }
            return filtered
        }
        // Metafilters are checked outside the lock (of course).
        let metathunk = metathunk ?? { _ in true }
        return Set(filtered.filter{ metathunk($0.value.metadata) }.keys)
    }
    
    /**
     Find the given key matching the metafilter query.
     
     This method will always return either an empty set or a set with one element.
     
     This method can return an empty set for one of three reasons.
     
     1. The `key` was not found.
     2. The `metafilter` query failed.
     3. The metadata was not of type `M`.
    */
    public static func filter<K: Keyed & Hashable, M>(key: K, metafilter: @escaping Metafilter<M>) -> Set<K> {
        guard let dependency = lock.read({ registrations[AnyKey(key)!] }) else { return [] }
        return metathunk(metafilter)(dependency.metadata) ? [key] : []
    }
    
    /**
     Find the given key with metadata equal to `metadata`.
     
     This method will always return either an empty set or a set with one element.
     
     This method can return an empty set for one of three reasons.
     
     1. The `key` was not found.
     2. The `metadata` was not `==` to the metadata associated with `key`.
     3. The metadata was not of type `M`.
    */
    public static func filter<K: Keyed & Hashable, M: Equatable>(key: K, metadata: M) -> Set<K> {
        return filter(key: key) { $0 == metadata }
    }
    
    /**
     Find the given key.
     
     This method returns a set with either zero or one members.
    */
    public static func filter<K: Keyed & Hashable>(key: K) -> Set<K> {
        return lock.read{ registrations[AnyKey(key)!] == nil ? [] : [key] }
    }
    
    /**
     Find all keys for the given type, name, and container, matching the given metadata filter.
     
     Because all of type, name, and container are specified, this method will return either
     an empty array or an array with a single value.
    */
    public static func filter<T, N: Hashable, C: Hashable, M>(type: T.Type, name: N, container: C, metafilter: @escaping Metafilter<M>) -> Set<Key<T>> {
        let key = Key<T>(name: name, container: container)
        return filter(key: key, metafilter: metafilter)
    }
    
    /**
     Find all keys for the given type, name, and container, having the specified metadata.
     
     Because all of type, name, and container are specified, this method will return either
     an empty array or an array with a single value.
    */
    public static func filter<T, N: Hashable, C: Hashable, M: Equatable>(type: T.Type, name: N, container: C, metadata: M) -> Set<Key<T>> {
        return filter(type: type, name: name, container: container) { $0 == metadata }
    }
    
    /**
     Find all keys for the given type, name, and container.
     
     Because all of type, name, and container are specified, this method will return either
     an empty array or an array with a single value.
     */
    public static func filter<T, N: Hashable, C: Hashable>(type: T.Type, name: N, container: C) -> Set<Key<T>> {
        let key = Key<T>(name: name, container: container)
        return filter(key: key)
    }
    
    /**
     Find all keys for the given type and name, matching the given metadata filter.
    */
    public static func filter<T, N: Hashable, M>(type: T.Type, name: N, metafilter: @escaping Metafilter<M>) -> Set<Key<T>> {
        return filter(type: String(reflecting: T.self), name: name, container: nil, metathunk: metathunk(metafilter))
    }
    
    /**
     Find all keys for the given type and name, having the specified metadata.
    */
    public static func filter<T, N: Hashable, M: Equatable>(type: T.Type, name: N, metadata: M) -> Set<Key<T>> {
        return filter(type: type, name: name) { $0 == metadata }
    }

    /**
     Find all keys for the given type and name.
     */
    public static func filter<T, N: Hashable>(type: T.Type, name: N) -> Set<Key<T>> {
        return filter(type: String(reflecting: T.self), name: name, container: nil)
    }
    
    /**
     Find all keys for the given type and container, matching the given metadata filter.
    */
    public static func filter<T, C: Hashable, M>(type: T.Type, container: C, metafilter: @escaping Metafilter<M>) -> Set<Key<T>> {
        return filter(type: String(reflecting: T.self), name: nil, container: container, metathunk: metathunk(metafilter))
    }

    /**
     Find all keys for the given type and container, having the specified metadata.
    */
    public static func filter<T, C: Hashable, M: Equatable>(type: T.Type, container: C, metadata: M) -> Set<Key<T>> {
        return filter(type: type, container: container) { $0 == metadata }
    }

    /**
     Find all keys for the given type and container, independent of name.
    */    
    public static func filter<T, C: Hashable>(type: T.Type, container: C) -> Set<Key<T>> {
        return filter(type: String(reflecting: T.self), name: nil, container: container)
    }
    
    /**
     Find all keys for the given name and container, independent of type.
    */
    public static func filter<N: Hashable, C: Hashable, M>(name: N, container: C, metafilter: @escaping Metafilter<M>) -> Set<AnyKey> {
        return filter(name: name, container: container, metafilter: metathunk(metafilter))
    }
    
    public static func filter<N: Hashable, C: Hashable, M: Equatable>(name: N, container: C, metadata: M) -> Set<AnyKey> {
        return filter(name: name, container: container) { $0 == metadata }
    }

    /**
     Find all keys for the given name and container, independent of type.
     */
    public static func filter<N: Hashable, C: Hashable>(name: N, container: C) -> Set<AnyKey> {
        return filter(name: name, container: container)
    }
    
    /**
     Find all keys for the given name, independent of the given type and container.
    */
    public static func filter<N: Hashable, M>(name: N, metafilter: @escaping Metafilter<M>) -> Set<AnyKey> {
        return filter(type: nil, name: name, container: nil, metathunk: metathunk(metafilter))
    }
    
    public static func filter<N: Hashable, M: Equatable>(name: N, metadata: M) -> Set<AnyKey> {
        return filter(name: name) { $0 == metadata }
    }

    /**
     Find all keys for the given name, independent of the given type and container.
     */
    public static func filter<N: Hashable>(name: N) -> Set<AnyKey> {
        return filter(type: nil, name: name, container: nil)
    }
    
    /**
     Find all keys for the given container, independent of given type and name.
    */
    public static func filter<C: Hashable, M>(container: C, metafilter: @escaping Metafilter<M>) -> Set<AnyKey> {
        return filter(type: nil, name: nil, container: container, metathunk: metathunk(metafilter))
    }
    
    public static func filter<C: Hashable, M: Equatable>(container: C, metadata: M) -> Set<AnyKey> {
        return filter(container: container) { $0 == metadata }
    }

    /**
     Find all keys for the given container, independent of type and name.
     */
    public static func filter<C: Hashable>(container: C) -> Set<AnyKey> {
        return filter(type: nil, name: nil, container: container)
    }
    
    /**
     Find all keys for the given type, independent of name and container.
    */
    public static func filter<T, M>(type: T.Type, metafilter: @escaping Metafilter<M>) -> Set<Key<T>> {
        return filter(type: nil, name: nil, container: nil, metathunk: metathunk(metafilter))
    }
    
    public static func filter<T, M: Equatable>(type: T.Type, metadata: M) -> Set<Key<T>> {
        return filter(type: type) { $0 == metadata }
    }
    
    /**
     Find all keys for the given type, independent of name and container.
     */
    public static func filter<T>(type: T.Type) -> Set<Key<T>> {
        return filter(type: nil, name: nil, container: nil)
    }
    
    /**
     Find all keys with registrations matching the metafilter query.
    */
    public static func filter<M>(metafilter: @escaping Metafilter<M>) -> Set<AnyKey> {
        return filter(type: nil, name: nil, container: nil, metathunk: metathunk(metafilter))
    }
    
    public static func filter<M: Equatable>(metadata: M) -> Set<AnyKey> {
        return filter{ $0 == metadata }
    }
    
    // MARK: Key Presence
    
    /**
     Helper method for filtering.
     */
    private static func exists(name: AnyHashable?, container: AnyHashable?, metathunk: Metathunk? = nil) -> Bool {
        return (filter(type: nil, name: name, container: container, metathunk: metathunk) as Set<AnyKey>).count > 0
    }
    
    private static func exists<T>(type: T.Type, name: AnyHashable?, container: AnyHashable?, metathunk: Metathunk? = nil) -> Bool {
        return (filter(type: String(reflecting: T.self), name: name, container: container, metathunk: metathunk) as Set<Key<T>>).count > 0
    }
    
    /**
     Returns true if a registration exists for `key` and matching the `metafilter` query.
    */
    public static func exists<M>(key: Keyed, metafilter: @escaping Metafilter<M>) -> Bool {
        guard let dependency = lock.read({ registrations[AnyKey(key)!] }) else { return false }
        return metathunk(metafilter)(dependency.metadata)
    }
    
    public static func exists<M: Equatable>(key: Keyed, metadata: M) -> Bool {
        return exists(key: key) { $0 == metadata }
    }

    /**
     Returns true if a registration exists for the given key.
     */
    public static func exists(key: Keyed) -> Bool {
        return lock.read { return registrations[AnyKey(key)!] != nil }
    }
    
    /**
     Returns true if a key with the given type, name, and container exists.
    */
    public static func exists<T, N: Hashable, C: Hashable, M>(type: T.Type, name: N, container: C, metafilter: @escaping Metafilter<M>) -> Bool {
        return exists(key: Key<T>(name: name, container: container), metafilter: metathunk(metafilter))
    }
    
    public static func exists<T, N: Hashable, C: Hashable, M: Equatable>(type: T.Type, name: N, container: C, metadata: M) -> Bool {
        return exists(key: Key<T>(name: name, container: container)) { $0 == metadata }
    }

    /**
     Returns true if a key with the given type, name, and container exists.
     */
    public static func exists<T, N: Hashable, C: Hashable>(type: T.Type, name: N, container: C) -> Bool {
        return exists(key: AnyKey(type: type, name: name, container: container)!)
    }
    
    /**
     Returns true if any keys with the given type and name exist in any containers.
    */
    public static func exists<T, N: Hashable, M>(type: T.Type, name: N, metafilter: @escaping Metafilter<M>) -> Bool {
        return exists(type: type, name: name, container: nil, metathunk: metathunk(metafilter))
    }
    
    public static func exists<T, N: Hashable, M: Equatable>(type: T.Type, name: N, metadata: M) -> Bool {
        return exists(type: type, name: name) { $0 == metadata }
    }
    
    /**
     Returns true if any keys with the given type and name exist in any containers.
     */
    public static func exists<T, N: Hashable>(type: T.Type, name: N) -> Bool {
        return exists(type: type, name: name, container: nil)
    }
    
    /**
     Returns true if any keys with the given type exist in the given container, independent of name.
    */
    public static func exists<T, C: Hashable, M>(type: T.Type, container: C, metafilter: @escaping Metafilter<M>) -> Bool {
        return exists(type: type, name: nil, container: container, metathunk: metathunk(metafilter))
    }
    
    public static func exists<T, C: Hashable, M: Equatable>(type: T.Type, container: C, metadata: M) -> Bool {
        return exists(type: type, container: container) { $0 == metadata }
    }

    /**
     Returns true if any keys with the given type exist in the given container, independent of name.
     */
    public static func exists<T, C: Hashable>(type: T.Type, container: C) -> Bool {
        return exists(type: type, name: nil, container: container)
    }
    
    /**
     Returns true if any keys with the given name exist in the given container, independent of type.
    */
    public static func exists<N: Hashable, C: Hashable, M>(name: N, container: C, metafilter: @escaping Metafilter<M>) -> Bool {
        return exists(name: name, container: container, metathunk: metathunk(metafilter))
    }
    
    public static func exists<N: Hashable, C: Hashable, M: Equatable>(name: N, container: C, metadata: M) -> Bool {
        return exists(name: name, container: container) { $0 == metadata }
    }

    /**
     Returns true if any keys with the given name exist in the given container, independent of type.
     */
    public static func exists<N: Hashable, C: Hashable>(name: N, container: C) -> Bool {
        return exists(name: name, container: container)
    }
    
    /**
     Return true if any keys with the given name exist in any container, independent of type.
    */
    public static func exists<N: Hashable, M>(name: N, metafilter: @escaping Metafilter<M>) -> Bool {
        return exists(name: name, container: nil, metathunk: metathunk(metafilter))
    }
    
    public static func exists<N: Hashable, M: Equatable>(name: N, metadata: M) -> Bool {
        return exists(name: name) { $0 == metadata }
    }
    
    /**
     Returns true if any registrations exist under the given name.
    */
    public static func exists<N: Hashable>(name: N) -> Bool {
        return exists(name: name, container: nil)
    }
    
    /**
     Returns true if there are any keys registered in the given container, matching the given metafilter query.
    */
    public static func exists<C: Hashable, M>(container: C, metafilter: @escaping Metafilter<M>) -> Bool {
        return exists(name: nil, container: container, metathunk: metathunk(metafilter))
    }
    
    /**
     Returns true if there are any keys registered in `container` and equal to `metadata`.
     */
    public static func exists<C: Hashable, M: Equatable>(container: C, metadata: M) -> Bool {
        return exists(container: container) { $0 == metadata }
    }

    /**
     Returns true if there are any keys registered in the given container.
     */
    public static func exists<C: Hashable>(container: C) -> Bool {
        return exists(name: nil, container: container)
    }
    
    /**
     Returns true if there are any keys registered with the given type and matching the metafilter query in any container, independent of name.
    */
    public static func exists<T, M>(type: T.Type, metafilter: @escaping Metafilter<M>) -> Bool {
        return exists(type: type, name: nil, container: nil, metathunk: metathunk(metafilter))
    }

    public static func exists<T, M: Equatable>(type: T.Type, metadata: M) -> Bool {
        return exists(type: type) { $0 == metadata }
    }
    
    /**
     Returns true if there are any keys registered with the given type in any container, independent of name.
     */
    public static func exists<T>(type: T.Type) -> Bool {
        return exists(type: type, name: nil, container: nil)
    }
    
    /**
     Returns true if any registrations exist matching the given metafilter, regardless of type, name, or container.
    */
    public static func exists<M>(metafilter: @escaping Metafilter<M>) -> Bool {
        return exists(name: nil, container: nil, metathunk: metathunk(metafilter))
    }
    
    public static func exists<M: Equatable>(metadata: M) -> Bool {
        return exists{ $0 == metadata }
    }
    
    // MARK: Metadata
    
    /**
     Retrieve metadata for the dependency registered under `key`.
     
     - parameter key: They key for which to retrieve the metadata.
     - returns: The registered metadata or `nil` if it does not exist or is not of type `M`.
    */
    public static func metadata<M>(for key: Keyed) -> M? {
        guard let dependency = lock.read({ registrations[AnyKey(key)!] }) else { return nil }
        guard let metadata = dependency.metadata as? M else { return nil }
        return metadata
    }
    
    /**
     Retrieve metadata for multiple keys.
     
     - parameter keys: The keys for which to retrieve the metadata.
     - returns: A dictionary of keys to metadata.
     
     - note: If a given key does not exist, or if its metadata is not of type `M`,
     it is simply skipped. This means that the number of entries in the returned
     dictionary may be less than the number of keys passed to the method.
    */
    public static func metadata<K: Keyed, M>(for keys: Set<K>) -> [K: M] {
        return lock.read {
            var metadatas = Dictionary<K, M>()
            for (key, dependency) in registrations {
                guard let key = K(key) else { continue }
                if !keys.contains(key) { continue }
                guard let metadata = dependency.metadata as? M else { continue }
                metadatas[key] = metadata
            }
            return metadatas
        }
    }
    
    // MARK: Unregistration
    
    /**
     Remove the dependencies registered under the given keys.
     
     - parameter keys: The keys to remove.
     - returns: The number of dependencies removed.
     */
    public static func unregister<K: Keyed>(keys: Set<K>) -> Int {
        return lock.write {
            let count = registrations.count
            registrations = registrations.filter {
                guard let key = K($0.key) else { return true }
                return !keys.contains(key)
            }
            return count - registrations.count
        }
    }
    
    /**
     Remove the dependencies registered under the given key(s).
     
     - parameter key: One or more keys to remove
     - returns: The number of dependencies removed.
    */
    public static func unregister<K: Keyed & Hashable>(key: K...) -> Int {
        return unregister(keys: Set(key))
    }

    /**
     Remove all dependencies of the given type, irrespective of name and container.
     
     - parameter type: The registered type of the dependencies to remove.
     - returns: The number of dependencies removed.
    */
    public static func unregister<T>(type: T.Type) -> Int {
        return unregister(keys: Guise.filter(type: type))
    }
    
    /**
     Remove all dependencies in the specified container.
     
     - parameter container: The container to empty.
     - returns: The number of dependencies removed.
    */
    public static func unregister<C: Hashable>(container: C) -> Int {
        return unregister(keys: Guise.filter(container: container))
    }
    
    /**
     Remove all dependencies of the given type in the specified container.
     
     - parameters:
        - type: The registered type of the dependencies to remove.
        - container: The container in which to search for dependencies to remove.
     - returns: The number of dependencies removed.
    */
    public static func unregister<T, C: Hashable>(type: T.Type, container: C) -> Int {
        return unregister(keys: Guise.filter(type: type, container: container))
    }
    
    /**
     Remove the dependency with the specified type, name, and container.
     
     - parameters:
        - type: The type of the dependency to remove.
        - name: The name of the dependency to remove.
        - container: The container of the dependency to remove.
     - returns: The number of dependencies removed, which for this method will be either 0 or 1.
     
     - note: This can affect only one registered dependency.
    */
    public static func unregister<T, N: Hashable, C: Hashable>(type: T.Type, name: N, container: C) -> Int {
        return unregister(key: Key<T>(name: name, container: container))
    }
    
    /**
     Remove all registrations. Reset Guise completely.
    */
    public static func clear() {
        lock.write { registrations = [:] }
    }
}

// MARK: -

/// A simple non-reentrant lock allowing one writer and multiple readers.
private class Lock {
    
    private let lock: UnsafeMutablePointer<pthread_rwlock_t> = {
        var lock = UnsafeMutablePointer<pthread_rwlock_t>.allocate(capacity: 1)
        let status = pthread_rwlock_init(lock, nil)
        assert(status == 0)
        return lock
    }()
    
    private func lock<T>(_ acquire: (UnsafeMutablePointer<pthread_rwlock_t>) -> Int32, block: () -> T) -> T {
        _ = acquire(lock)
        defer { pthread_rwlock_unlock(lock) }
        return block()
    }
    
    func read<T>(_ block: () -> T) -> T {
        return lock(pthread_rwlock_rdlock, block: block)
    }
    
    func write<T>(_ block: () -> T) -> T {
        return lock(pthread_rwlock_wrlock, block: block)
    }
    
    deinit {
        pthread_rwlock_destroy(lock)
    }
}

// MARK: - Extensions

extension Array {
    /**
     Reconstruct a dictionary after it's been reduced to an array of key-value pairs by `filter` and the like.
     
     ```
     var dictionary = [1: "ok", 2: "crazy", 99: "abnormal"]
     dictionary = dictionary.filter{ $0.value == "ok" }.dictionary()
     ```
    */
    func dictionary<K: Hashable, V>() -> [K: V] where Element == Dictionary<K, V>.Element {
        var dictionary = [K: V]()
        for element in self {
            dictionary[element.key] = element.value
        }
        return dictionary
    }
}

extension Sequence where Iterator.Element: Keyed {
    /**
     Returns a set up of typed `Key<T>`.
     
     Any of the underlying keys whose type is not `T`
     will simply be omitted, so this is also a way
     to filter a sequence of keys by type.
     */
    public func typedKeys<T>() -> Set<Key<T>> {
        return Set<Key<T>>(flatMap{ Key($0) })
    }
    
    /**
     Returns a set of untyped `AnyKey`.
     
     This is a convenient way to turn a set of typed
     keys into a set of untyped keys.
     */
    public func untypedKeys() -> Set<AnyKey> {
        return Set(map{ AnyKey($0)! })
    }
}

/**
 This typealias exists to disambiguate Guise's `Key<T>`
 from the `Key` generic type parameter in `Dictionary`.
 
 It is exactly equivalent to `Key<T>` and can be safely
 ignored.
 */
public typealias GuiseKey<T> = Key<T>

extension Dictionary where Key: Keyed {
    /**
     Returns a dictionary in which the keys hold the type `T`.
     
     Any key which does not hold `T` is simply skipped, along with
     its corresponding value, so this is also a way to filter
     a sequence of keys by type.
     */
    public func typedKeys<T>() -> Dictionary<GuiseKey<T>, Value> {
        return flatMap {
            guard let key = GuiseKey<T>($0.key) else { return nil }
            return (key: key, value: $0.value)
        }.dictionary()
    }
    
    /**
     Returns a dictionary in which the keys are `AnyKey`.
     
     This is a convenient way to turn a dictionary with typed keys
     into a dictionary with type-erased keys.
     */
    public func untypedKeys() -> Dictionary<AnyKey, Value> {
        return map{ (key: AnyKey($0.key)!, value: $0.value) }.dictionary()
    }
}

// Miscellanea: -

/**
 Generates a hash value for one or more hashable values.
 */
private func hash<H: Hashable>(_ hashables: H...) -> Int {
    // djb2 hash algorithm: http://www.cse.yorku.ca/~oz/hash.html
    // &+ operator handles Int overflow
    return hashables.reduce(5381) { (result, hashable) in ((result << 5) &+ result) &+ hashable.hashValue }
}

infix operator ??= : AssignmentPrecedence

private func ??=<T>(lhs: inout T?, rhs: @autoclosure () -> T?) {
    if lhs != nil { return }
    lhs = rhs()
}

