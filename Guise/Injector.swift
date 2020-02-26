//
//  Injector.swift
//  Guise
//
//  Created by Gregory Higley on 2/26/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public struct Injector<Target: AnyObject> {
  private var injections: [(Resolver, Target, [AnyHashable: Any]) -> Void] = []

  public init() {}

  public func inject(_ injection: @escaping (Resolver, Target, [AnyHashable: Any]) -> Void) -> Injector<Target> {
    var injector = self
    injector.injections.append(injection)
    return injector
  }

  public func inject<Type>(exact keyPath: ReferenceWritableKeyPath<Target, Type>, scope: Scope = .default, arg: AnyHashable = UUID()) -> Injector<Target> {
    return inject { (r, target, args) in
      target[keyPath: keyPath] = r.resolve(arg: args[arg] ?? ())!
    }
  }

  public func inject<Type>(_ keyPath: ReferenceWritableKeyPath<Target, Type?>, scope: Scope = .default, arg: AnyHashable = UUID()) -> Injector<Target> {
    return inject { (r, target, args) in
      target[keyPath: keyPath] = r.resolve(arg: args[arg] ?? ())
    }
  }
}
