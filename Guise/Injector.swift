//
//  Injector.swift
//  Guise
//
//  Created by Gregory Higley on 3/2/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public struct Injector<Target: AnyObject> {
  private let registrar: Registrar
  private var injections: [Inject<Target>] = []

  public init(_ registrar: Registrar) {
    self.registrar = registrar
  }

  public func inject<Value>(exact keyPath: ReferenceWritableKeyPath<Target, Value>, type: Value.Type = Value.self, in scope: Scope = .default) -> Injector<Target> {
    var injector = self
    injector.injections.append { r, o, args in
      let arg = scope / type
      o[keyPath: keyPath] = r.resolve(type: type, in: scope, arg: args[arg] ?? ())!
    }
    return injector
  }

  public func inject<Value>(_ keyPath: ReferenceWritableKeyPath<Target, Value?>, type: Value.Type = Value.self, in scope: Scope = .default) -> Injector<Target> {
    var injector = self
    injector.injections.append { r, o, args in
      let arg = scope / type
      o[keyPath: keyPath] = r.resolve(type: type, in: scope, arg: args[arg] ?? ())
    }
    return injector
  }

  @discardableResult public func register() -> Key {
    let key: Key = .injections / Target.self
    let injections = self.injections
    registrar[key] = KeyPathInjection { (r: Resolver, o: Target, args: [Key: Any]) in
      for inject in injections {
        inject(r, o, args)
      }
    }
    return key
  }
}
