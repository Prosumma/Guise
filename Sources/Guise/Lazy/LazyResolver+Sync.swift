//
//  LazyResolver+Sync.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

public extension LazyResolver {
  func resolve<A>(name: AnyHashable..., args arg1: A = ()) throws -> T {
    try resolve(name: Set(name), args: arg1)
  }
}
