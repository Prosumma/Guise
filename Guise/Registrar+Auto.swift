//
//  Registrar+Auto.swift
//  Guise
//
//  Created by Gregory Higley on 2/26/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public typealias AutoregistrationResult<Type> = (Resolver, Void) -> Type

private func makeauto<Type>(_ block: @escaping (Resolver) -> Type) -> AutoregistrationResult<Type> {
  return { (r, _) in
    block(r)
  }
}

public func auto<Type, Arg>(_ resolve: @escaping (Arg) -> Type, in scope: Scope = .default, as type: Type.Type = Type.self) -> AutoregistrationResult<Type> {
  makeauto { r in resolve(r.resolve(in: scope)!) }
}

public func auto<Type, Arg1, Arg2>(_ resolve: @escaping (Arg1, Arg2) -> Type, in scope: Scope = .default, as type: Type.Type = Type.self) -> AutoregistrationResult<Type> {
  makeauto { r in resolve(r.resolve(in: scope)!, r.resolve(in: scope)!) }
}

public func auto<Type, Arg1, Arg2, Arg3>(_ resolve: @escaping (Arg1, Arg2, Arg3) -> Type, in scope: Scope = .default, as type: Type.Type = Type.self) -> AutoregistrationResult<Type> {
  makeauto { r in resolve(r.resolve(in: scope)!, r.resolve(in: scope)!, r.resolve(in: scope)!) }
}

