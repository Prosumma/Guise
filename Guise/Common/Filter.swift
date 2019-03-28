//
//  Filter.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolving {
    
    /**
     Gets the registered keys.
     
     Keys are unique identifiers for block registrations.
     (Injections just use strings as keys.)
     
     This returns a `Set` of `AnyKey` instances, because
     the keys may register heterogeneous types.
     
     See `Keyed`, `AnyKey`, `Key<T>` and the various
     `register` overloads for more information on keys.
     */
    var keys: Set<AnyKey> {
        return Set(filter().keys)
    }
    
    /// Returns the `Registration` (if any) registered under `key`.
    func filter<K: Keyed & Hashable>(key: K) -> Registration? {
        return filter{ $0 == key }.values.first
    }
    
    /// Returns a dictionary of keys to registrations for the given keys.
    func filter<Keys: Sequence>(keys: Keys) -> [Keys.Element: Registration] where Keys.Element: Keyed {
        return filter{ keys.contains($0) }
    }
    
    /**
     Returns a dictionary of keys to registrations where the key matches
     the specified criteria. The criteria are the `name` and `container`.
     If either of `name` or `container` are `nil`, they are ignored for
     the purposes of matching.
    
     For example:
     
     ```
     let criteria = Criteria(name: Name.foo, container: nil)
     let registrations = Guise.filter(criteria: criteria)
        as [AnyKey: Registration]
     ```
     
     The example above finds any registrations with the name `Name.foo` across
     all containers and with any registered type. To filter for a specific type,
     use `Key<T>` instead of `AnyKey`:
     
     ```
     let registrations = Guise.filter(criteria: criteria)
        as [Key<Dependency>: Registration]
     ```
     
     In the example above, only those registrations which register a `Dependency`
     will be returned.
     
     - note: This is a fairly low-level overload upon which others are based.
     It's probably best to use the higher-level overloads such as `filter(type:name:container:)`
     instead.
     */
    func filter<K: Keyed>(criteria: Criteria) -> [K: Registration] {
        return filter{ $0 ~= criteria }
    }
    
    /**
     Returns those registrations which match `criteria` *and* the metadata filter. To
     pass a metadata filter, the target metadata must be of a compatible type (determined
     by Swift's `as?` operator) and the metadata filter must return `true`.
     
     ```
     let criteria = Criteria(name: nil, container: Container.awesome)
     let registrations = Guise.filter(criteria: criteria) { (metadata: Int) in metadata > 3 }
     ```
     */
    func filter<K: Keyed, Metadata>(criteria: Criteria, metafilter: @escaping Metafilter<Metadata>) -> [K: Registration] {
        return filter(criteria: criteria).filter(metathunk(metafilter))
    }
    
    /**
     Returns those registrations which match `criteria` *and* are `==` to the given `metadata`.
     The target metadata must be of a compatible type (determined by Swift's `as?` operator) and
     `Metadata` must be `Equatable`.
     
     ```
     let criteria = Criteria(name: nil, container: Container.awesome)
     let registrations = Guise.filter(criteria: criteria, metadata: 3)
     ```
     */
    func filter<K: Keyed, Metadata: Equatable>(criteria: Criteria, metadata: Metadata) -> [K: Registration] {
        return filter(criteria: criteria) { $0 == metadata }
    }
    
    /**
     Returns those registrations which have the registered `type` and which match `name` and `container`.
     If `name` and/or `container` are `nil`, they are ignored for the purposes of matching.
     
     - parameter type: The registered type to match.
     - parameter name: The name to match or `nil` to match all names.
     - parameter container: The container to match or `nil` to match all containers.
     
     - returns: A dictionary of `Key<RegisteredType>` to `Registration`.
     */
    func filter<RegisteredType>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) -> [Key<RegisteredType>: Registration] {
        return filter(criteria: Criteria(name: name, container: container))
    }
    
    /**
     Returns those registrations which have the registered `type` and which match `name`, `container`,
     and pass the metadata filter. To pass a metadata filter, the target metadata must be of a
     compatible type (determined by Swift's `as?` operator) and the metadata filter must return `true`.
     If `name` and/or `container` are `nil`, they are ignored for the purposes of matching.
     
     - parameter type: The registered type to match.
     - parameter name: The name to match or `nil` to match all names.
     - parameter container: The container to match or `nil` to match all containers.
     - parameter metafilter: A metadata filter to match against registrations.
     
     - returns: A dictionary of `Key<RegisteredType>` to `Registration`.
     */
    func filter<RegisteredType, Metadata>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<Metadata>) -> [Key<RegisteredType>: Registration] {
        return filter(criteria: Criteria(name: name, container: container)).filter(metathunk(metafilter))
    }
    
    /**
     Returns those registrations which have the registered `type` and which match `name`, `container`,
     and are `==` to `metadata`. The target metadata must be of a compatible type (determined by Swift's
     `as?` operator) and `Metadata` must be `Equatable`. If `name` and/or `container` are `nil`, they
     are ignored for the purposes of matching.
     
     - parameter type: The registered type to match.
     - parameter name: The name to match or `nil` to match all names.
     - parameter container: The container to match or `nil` to match all containers.
     - parameter metafilter: A metadata filter to match against registrations.
     
     - returns: A dictionary of `Key<RegisteredType>` to `Registration`.
     */
    func filter<RegisteredType, Metadata: Equatable>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: Metadata) -> [Key<RegisteredType>: Registration] {
        return filter(type: type, name: name, container: container) { $0 == metadata }
    }
    
    /**
     Returns those registrations which match `name` and/or `container`. The registrations
     can register any type. Passing `nil` for `name` or `container` matches any `name`
     or `container` respectively. Omitting both produces a filter which matches all registrations.
     */
    func filter(name: AnyHashable? = nil, container: AnyHashable? = nil) -> [AnyKey: Registration] {
        return filter(criteria: Criteria(name: name, container: container))
    }
    
    /**
     Returns those registrations which match `name`, `container`, and the metadata filter `metafilter`.
     To pass a metadata filter, the target metadata must be of a compatible type (determined by Swift's
     `as?` operator) and the metadata filter must return `true`. If `name` and/or `container` are `nil`,
     they are ignored for the purposes of matching.
     */
    func filter<Metadata>(name: AnyHashable?, container: AnyHashable?, metafilter: @escaping Metafilter<Metadata>) -> [AnyKey: Registration] {
        return filter(criteria: Criteria(name: name, container: container)).filter(metathunk(metafilter))
    }

    /**
     Returns those registrations which match `name`, `container`, and are `==` to `metadata`.
     The target metadata must be of a compatible type (determined by Swift's `as?` operator)
     and `Metadata` must be `Equatable`. If `name` and/or `container` are `nil`, they are ignored
     for the purposes of matching.
     */
    func filter<Metadata: Equatable>(name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: Metadata) -> [AnyKey: Registration] {
        return filter(name: name, container: container) { $0 == metadata }
    }
}

public extension _Guise {
    
    /**
     Gets the registered keys.
     
     Keys are unique identifiers for block registrations.
     (Injections just use strings as keys.)
     
     This returns a `Set` of `AnyKey` instances, because
     the keys may register heterogeneous types.
     
     See `Keyed`, `AnyKey`, `Key<T>` and the various
     `register` overloads for more information on keys.
     */
    static var keys: Set<AnyKey> {
        return resolver.keys
    }
    
    /// Returns the `Registration` (if any) registered under `key`.
    static func filter<K: Keyed & Hashable>(key: K) -> Registration? {
        return resolver.filter(key: key)
    }
    
    /// Returns a dictionary of keys to registrations for the given keys.
    static func filter<Keys: Sequence>(keys: Keys) -> [Keys.Element: Registration] where Keys.Element: Keyed {
        return resolver.filter(keys: keys)
    }
    
    /**
     Returns a dictionary of keys to registrations where the key matches
     the specified criteria. The criteria are the `name` and `container`.
     If either of `name` or `container` are `nil`, they are ignored for
     the purposes of matching.
     
     For example:
     
     ```
     let criteria = Criteria(name: Name.foo, container: nil)
     let registrations = Guise.filter(criteria: criteria)
     as [AnyKey: Registration]
     ```
     
     The example above finds any registrations with the name `Name.foo` across
     all containers and with any registered type. To filter for a specific type,
     use `Key<T>` instead of `AnyKey`:
     
     ```
     let registrations = Guise.filter(criteria: criteria)
     as [Key<Dependency>: Registration]
     ```
     
     In the example above, only those registrations which register a `Dependency`
     will be returned.
     
     - note: This is a fairly low-level overload upon which others are based.
     It's probably best to use the higher-level overloads such as `filter(type:name:container:)`
     instead.
     */
    static func filter<K: Keyed>(criteria: Criteria) -> [K: Registration] {
        return resolver.filter(criteria: criteria)
    }
    
    /**
     Returns those registrations which match `criteria` *and* the metadata filter. To
     pass a metadata filter, the target metadata must be of a compatible type (determined
     by Swift's `as?` operator) and the metadata filter must return `true`.
     
     ```
     let criteria = Criteria(name: nil, container: Container.awesome)
     let registrations = Guise.filter(criteria: criteria) { (metadata: Int) in metadata > 3 }
     ```
     */
    static func filter<K: Keyed, Metadata>(criteria: Criteria, metafilter: @escaping Metafilter<Metadata>) -> [K: Registration] {
        return resolver.filter(criteria: criteria, metafilter: metafilter)
    }
    
    /**
     Returns those registrations which match `criteria` *and* are `==` to the given `metadata`.
     The target metadata must be of a compatible type (determined by Swift's `as?` operator) and
     `Metadata` must be `Equatable`.
     
     ```
     let criteria = Criteria(name: nil, container: Container.awesome)
     let registrations = Guise.filter(criteria: criteria, metadata: 3)
     ```
     */
    static func filter<K: Keyed, Metadata: Equatable>(criteria: Criteria, metadata: Metadata) -> [K: Registration] {
        return resolver.filter(criteria: criteria, metadata: metadata)
    }
    
    /**
     Returns those registrations which have the registered `type` and which match `name` and `container`.
     If `name` and/or `container` are `nil`, they are ignored for the purposes of matching.
     
     - parameter type: The registered type to match.
     - parameter name: The name to match or `nil` to match all names.
     - parameter container: The container to match or `nil` to match all containers.
     
     - returns: A dictionary of `Key<RegisteredType>` to `Registration`.
     */
    static func filter<RegisteredType>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil) -> [Key<RegisteredType>: Registration] {
        return resolver.filter(type: type, name: name, container: container)
    }
    
    /**
     Returns those registrations which have the registered `type` and which match `name`, `container`,
     and pass the metadata filter. To pass a metadata filter, the target metadata must be of a
     compatible type (determined by Swift's `as?` operator) and the metadata filter must return `true`.
     If `name` and/or `container` are `nil`, they are ignored for the purposes of matching.
     
     - parameter type: The registered type to match.
     - parameter name: The name to match or `nil` to match all names.
     - parameter container: The container to match or `nil` to match all containers.
     - parameter metafilter: A metadata filter to match against registrations.
     
     - returns: A dictionary of `Key<RegisteredType>` to `Registration`.
     */
    static func filter<RegisteredType, Metadata>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<Metadata>) -> [Key<RegisteredType>: Registration] {
        return resolver.filter(type: type, name: name, container: container, metafilter: metafilter)
    }
    
    /**
     Returns those registrations which have the registered `type` and which match `name`, `container`,
     and are `==` to `metadata`. The target metadata must be of a compatible type (determined by Swift's
     `as?` operator) and `Metadata` must be `Equatable`. If `name` and/or `container` are `nil`, they
     are ignored for the purposes of matching.
     
     - parameter type: The registered type to match.
     - parameter name: The name to match or `nil` to match all names.
     - parameter container: The container to match or `nil` to match all containers.
     - parameter metafilter: A metadata filter to match against registrations.
     
     - returns: A dictionary of `Key<RegisteredType>` to `Registration`.
     */
    static func filter<RegisteredType, Metadata: Equatable>(type: RegisteredType.Type, name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: Metadata) -> [Key<RegisteredType>: Registration] {
        return resolver.filter(type: type, name: name, container: container, metadata: metadata)
    }
    
    /**
     Returns those registrations which match `name` and/or `container`. The registrations
     can register any type. Passing `nil` for `name` or `container` matches any `name`
     or `container` respectively. Omitting both produces a filter which matches all registrations.
     */
    static func filter(name: AnyHashable? = nil, container: AnyHashable? = nil) -> [AnyKey: Registration] {
        return resolver.filter(name: name, container: container)
    }
    
    /**
     Returns those registrations which match `name`, `container`, and the metadata filter `metafilter`.
     To pass a metadata filter, the target metadata must be of a compatible type (determined by Swift's
     `as?` operator) and the metadata filter must return `true`. If `name` and/or `container` are `nil`,
     they are ignored for the purposes of matching.
     */
    static func filter<Metadata>(name: AnyHashable? = nil, container: AnyHashable? = nil, metafilter: @escaping Metafilter<Metadata>) -> [AnyKey: Registration] {
        return resolver.filter(name: name, container: container, metafilter: metafilter)
    }
    
    /**
     Returns those registrations which match `name`, `container`, and are `==` to `metadata`.
     The target metadata must be of a compatible type (determined by Swift's `as?` operator)
     and `Metadata` must be `Equatable`. If `name` and/or `container` are `nil`, they are ignored
     for the purposes of matching.
     */
    static func filter<Metadata: Equatable>(name: AnyHashable? = nil, container: AnyHashable? = nil, metadata: Metadata) -> [AnyKey: Registration] {
        return resolver.filter(name: name, container: container, metadata: metadata)
    }
    
}
