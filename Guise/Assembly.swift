//
//  Assembly.swift
//  Guise
//
//  Created by Gregory Higley on 3/3/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

/**
 An `Assembly` is a grouping of registrations
 which can be made together. This allows
 Guise to be used effectively across framework
 and other module boundaries.

 A framework should export a single public
 implementation of `Assembly` as a _type_
 rather than an instance of a type.
 
 Assemblies may depend upon other assemblies,
 as follows:
 
 ```swift
 // This exports the type `OtherAssembly`.
 import OtherFramework
 
 public struct MyAssembly: Assembly {
  public func register(in registrar: Registrar) {
    registrar.register(singleton: SomeSingleton())
    registrar.register(transient: auto(Awesome.init))
    // Dependent assembly
    registrar.register(assembly: OtherAssembly())
  }
 }
 ```
 
 _Guise prevents the same assembly from being
 registered more than once._ This means that if
 a nested assembly is registered multiple times,
 subsequent registrations do nothing.
 
 To force re-registration of an assembly, discard
 its assembly key and register it again.
 
 ```swift
 registrar.discard(key: .assemblies / OtherAssembly.self)
 registrar.register(assembly: MyAssembly())
 ```
 */
public protocol Assembly {
  /**
   When an `Assembly` is registered, this method is called
   and the `Registrar` passes itself as an argument.

   - warning: If the `Registrar` passed to `register(in:)` does
   not also implement `Resolver`, `registered(to:)` will not
   be called.
   */
  func register(in registrar: Registrar & Resolver)

  /**
   Called after `register(in:)` has succeeded. Use it to perform
   post-registration actions if needed.

   - warning: If the `Registrar` passed to `register(in:)` does
   not also implement `Resolver`, this method will not be called.
   */
  func registered(to resolver: Resolver)
}

public extension Assembly {
  /**
   Called after `register(in:)` has succeeded. Use it to perform
   post-registration actions if needed.

   - warning: If the `Registrar` passed to `register(in:)` does
   not also implement `Resolver`, this method will not be called.
   */
  func registered(to resolver: Resolver) {
    // Default implementation does nothing
  }
}
