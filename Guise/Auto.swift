//
//  Auto.swift
//  Guise
//
//  Created by Gregory Higley on 3/2/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public func auto<Type, Arg>(_ initializer: @escaping (Arg) -> Type, scope: Scope = .default) -> Resolve<Void, Type> {
  return { r, _ in
    initializer(r.resolve(in: scope)!)
  }
}

public func auto<Type, Arg1, Arg2>(_ initializer: @escaping (Arg1, Arg2) -> Type, scope1: Scope = .default, scope2: Scope = .default) -> Resolve<Void, Type> {
  return { r, _ in
    initializer(r.resolve(in: scope1)!, r.resolve(in: scope2)!)
  }
}

public func auto<Type, Arg1, Arg2>(_ initializer: @escaping (Arg1, Arg2) -> Type, scope: Scope) -> Resolve<Void, Type> {
  return { r, _ in
    initializer(r.resolve(in: scope)!, r.resolve(in: scope)!)
  }
}

public func auto<Type, Arg1, Arg2, Arg3>(_ initializer: @escaping (Arg1, Arg2, Arg3) -> Type, scope1: Scope = .default, scope2: Scope = .default, scope3: Scope = .default) -> Resolve<Void, Type> {
  return { r, _ in
    initializer(r.resolve(in: scope1)!, r.resolve(in: scope2)!, r.resolve(in: scope3)!)
  }
}

public func auto<Type, Arg1, Arg2, Arg3>(_ initializer: @escaping (Arg1, Arg2, Arg3) -> Type, scope: Scope) -> Resolve<Void, Type> {
  return { r, _ in
    initializer(r.resolve(in: scope)!, r.resolve(in: scope)!, r.resolve(in: scope)!)
  }
}

public func auto<Type, Arg1, Arg2, Arg3, Arg4>(_ initializer: @escaping (Arg1, Arg2, Arg3, Arg4) -> Type, scope: Scope) -> Resolve<Void, Type> {
  return { r, _ in
    initializer(r.resolve(in: scope)!, r.resolve(in: scope)!, r.resolve(in: scope)!, r.resolve(in: scope)!)
  }
}

public func auto<Type, Arg1, Arg2, Arg3, Arg4, Arg5>(_ initializer: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5) -> Type, scope: Scope) -> Resolve<Void, Type> {
  return { r, _ in
    initializer(r.resolve(in: scope)!, r.resolve(in: scope)!, r.resolve(in: scope)!, r.resolve(in: scope)!, r.resolve(in: scope)!)
  }
}

