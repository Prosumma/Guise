//
//  FactoryBuilder.swift
//  
//
//  Created by Gregory Higley on 3/28/20.
//

import Foundation

public protocol FactoryBuilderProtocol {
  var builder: FactoryBuilder { get }
}

open class FactoryBuilder: FactoryBuilderProtocol {
  
  public struct StateKey: Hashable {
    public let identifier = UUID()
    public init() {}
    
    public static let lifetime = StateKey()
    public static let scope = StateKey()
    public static let metadata = StateKey()
  }
  
  public required init(registrar: Registrar) {
    self.registrar = registrar
  }
  
  public let registrar: Registrar
  private var state: HeterogeneousDictionary<StateKey> = [:]
  
  public final subscript<Value>(key: StateKey) -> Value? {
    get { state[key] }
    set { state[key] = newValue }
  }
  
  public var builder: FactoryBuilder {
    return self
  }
  
  @discardableResult
  open func register<Type, Arg>(type: Type.Type = Type.self, factory: @escaping (Resolver, Arg) -> Type) -> Key {
    let scope: Scope = builder[.scope] ?? .default
    let key: Key = scope / type
    let lifetime: Lifetime = builder[.lifetime] ?? .transient
    let metadata: Any = builder[.metadata] ?? ()
    builder.registrar[key] = lifetime.register(type: type, factory: factory, metadata: metadata)
    return key
  }
}

public extension FactoryBuilderProtocol {
  @discardableResult
  func register<Type, Arg>(type: Type.Type = Type.self, factory: @escaping (Resolver, Arg) -> Type) -> Key {
    builder.register(type: type, factory: factory)
  }
  
  func build<Value>(_ key: FactoryBuilder.StateKey, _ value: Value) -> FactoryBuilder {
    let b = builder
    b[key] = value
    return b
  }
  
  func lifetime(_ lifetime: Lifetime) -> FactoryBuilder {
    build(.lifetime, lifetime)
  }
  
  func metadata(_ metadata: Any) -> FactoryBuilder {
    build(.metadata, metadata)
  }
  
  func `in`(_ scope: Scope) -> FactoryBuilder {
    build(.scope, scope)
  }
  
  var transient: FactoryBuilder {
    lifetime(.transient)
  }
  
  var singleton: FactoryBuilder {
    lifetime(.singleton)
  }
  
  var `weak`: FactoryBuilder {
    lifetime(.weak)
  }
  
  @discardableResult
  func register<Type>(type: Type.Type = Type.self, factory: @escaping (Resolver) -> Type) -> Key {
    builder.register(type: type) { (resolver, _: Void) in
      factory(resolver)
    }
  }
    
  @discardableResult
  func register<Type, Arg1, Arg2>(type: Type.Type = Type.self, factory: @escaping (Resolver, Arg1, Arg2) -> Type) -> Key {
    builder.register(type: type) { (resolver, arg: (Arg1, Arg2)) in
      factory(resolver, arg.0, arg.1)
    }
  }
  
  @discardableResult
  func register<Type>(transient: @escaping @autoclosure () -> Type) -> Key {
    lifetime(.transient).register { _ in
      transient()
    }
  }
  
  @discardableResult
  func register<Type>(singleton: @escaping @autoclosure () -> Type) -> Key {
    lifetime(.singleton).register { _ in
      singleton()
    }
  }
  
  @discardableResult
  func register<Type: AnyObject>(weak weakling: Type) -> Key {
    let scope: Scope = builder[.scope] ?? .default
    let key = scope / Type.self
    builder.registrar[key] = WeakFactory(weakling, metadata: builder[.metadata] ?? ())
    return key
  }
}
