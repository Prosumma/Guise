//
//  Auto.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

public typealias Resolution<T> = (any Resolver) throws -> T

public func auto<T>(_ initializer: @escaping () throws -> T) -> Resolution<T> {
  return { _ in
    try initializer()
  }
}

public func auto<T, A1>(_ initializer: @escaping (A1) throws -> T) -> Resolution<T> {
  return { r in
    try initializer(r.resolve())
  }
}

public func auto<T, A1, A2>(_ initializer: @escaping (A1, A2) throws -> T) -> Resolution<T> {
  return { r in
    try initializer(
      r.resolve(),
      r.resolve()
    )
  }
}
