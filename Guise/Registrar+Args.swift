//
//  Resolver+Args.swift
//  Guise
//
//  Created by Gregory Higley on 2/26/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public typealias PassResult<Arg, Type> = (Resolver, Arg) -> Type

private func makepass<Arg, Type>(_ block: @escaping (Arg) -> Type) -> PassResult<Arg, Type> {
  return { (_, args) in block(args) }
}

public func pass<Type>(to resolve: @escaping () -> Type, as type: Type.Type = Type.self) -> PassResult<Void, Type> {
  makepass { _ in resolve() }
}

public func pass<Type, Arg1, Arg2>(to resolve: @escaping (Arg1, Arg2) -> Type, as type: Type.Type = Type.self) -> PassResult<(Arg1, Arg2), Type> {
  makepass { args in resolve(args.0, args.1) }
}

public func pass<Type, Arg1, Arg2, Arg3>(to resolve: @escaping (Arg1, Arg2, Arg3) -> Type, as type: Type.Type = Type.self) -> PassResult<(Arg1, Arg2, Arg3), Type> {
  makepass { args in resolve(args.0, args.1, args.2) }
}

public extension Registrar {

  @discardableResult func register<Type, Arg>(type: Type.Type = Type.self, in scope: Scope = .default, lifetime: Lifetime = .factory, metadata: Any = (), resolve: @escaping (Resolver, Arg) -> Type) -> Key {
    let key = Key(type, in: scope)
    self[key] = lifetime.registrationType.init(resolve: resolve, metadata: metadata)
    return key
  }

  @discardableResult func register<Type>(type: Type.Type = Type.self, in scope: Scope = .default, lifetime: Lifetime = .factory, metadata: Any = (), resolve: @escaping (Resolver) -> Type) -> Key {
    register(type: type, in: scope, lifetime: lifetime, metadata: metadata) { (r: Resolver, _: Void) in
      resolve(r)
    }
  }

  @discardableResult func register<Type, Arg1, Arg2>(type: Type.Type = Type.self, in scope: Scope = .default, lifetime: Lifetime = .factory, metadata: Any = (), resolve: @escaping (Resolver, Arg1, Arg2) -> Type) -> Key {
    register(type: type, in: scope, lifetime: lifetime, metadata: metadata) { (r: Resolver, args: (Arg1, Arg2)) in
      resolve(r, args.0, args.1)
    }
  }

}
