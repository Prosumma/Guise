//
//  Collection+Resolve.swift
//  
//
//  Created by Gregory Higley on 3/28/20.
//

import Foundation

public extension Sequence where Element: FactoryRegistration {
  func resolve<Type>(type: Type.Type = Type.self, resolver: Resolver) -> [Type] {
    resolve(type: type, resolver: resolver, arg: ())
  }
  
  func resolve<Type, Arg>(type: Type.Type = Type.self, resolver: Resolver, arg: Arg) -> [Type] {
    compactMap{ $0.resolve(type: type, resolver: resolver, arg: arg) }
  }
  
  func resolve<Type, Arg1, Arg2>(type: Type.Type = Type.self, resolver: Resolver, arg1: Arg1, arg2: Arg2) -> [Type] {
    resolve(type: type, resolver: resolver, arg: (arg1, arg2))
  }
}

public extension Dictionary where Key == Scope, Value: FactoryRegistration {
  func resolve<Type>(type: Type.Type = Type.self, resolver: Resolver) -> [Key: Type] {
    resolve(type: type, resolver: resolver, arg: ())
  }
  
  func resolve<Type, Arg>(type: Type.Type = Type.self, resolver: Resolver, arg: Arg) -> [Key: Type] {
    let keyValues: [(Key, Type)] = compactMap { kv in
      guard let value = kv.value.resolve(type: type, resolver: resolver, arg: arg) else {
        return nil
      }
      return (kv.key, value)
    }
    return Dictionary<Key, Type>(uniqueKeysWithValues: keyValues)
  }
  
  func resolve<Type, Arg1, Arg2>(type: Type.Type = Type.self, resolver: Resolver, arg1: Arg1, arg2: Arg2) -> [Key: Type] {
    resolve(type: type, resolver: resolver, arg: (arg1, arg2))
  }
}
