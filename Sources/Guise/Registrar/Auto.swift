//
//  Auto.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

public typealias Resolution<T> = (any Resolver) throws -> T

#if swift(>=5.9)

public func auto<T, each D>(
  _ initializer: @escaping (repeat each D) throws -> T
) -> Resolution<T> {
  return { r in
    try initializer(repeat r.resolve() as (each D))
  }
}

#else

public func auto<T, A1>(
  _ initializer: @escaping (A1) throws -> T
) -> Resolution<T> {
  return { r in
    try initializer(
      r.resolve()
    )
  }
}

public func auto<T, A1, A2>(
  _ initializer: @escaping (A1, A2) throws -> T
) -> Resolution<T> {
  return { r in
    try initializer(
      r.resolve(),
      r.resolve()
    )
  }
}

public func auto<T, A1, A2, A3>(
  _ initializer: @escaping (A1, A2, A3) throws -> T
) -> Resolution<T> {
  return { r in
    try initializer(
      r.resolve(),
      r.resolve(),
      r.resolve()
    )
  }
}

public func auto<T, A1, A2, A3, A4>(
  _ initializer: @escaping (A1, A2, A3, A4) throws -> T
) -> Resolution<T> {
  return { r in
    try initializer(
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve()
    )
  }
}

public func auto<T, A1, A2, A3, A4, A5>(
  _ initializer: @escaping (A1, A2, A3, A4, A5) throws -> T
) -> Resolution<T> {
  return { r in
    try initializer(
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve()
    )
  }
}

public func auto<T, A1, A2, A3, A4, A5, A6>(
  _ initializer: @escaping (A1, A2, A3, A4, A5, A6) throws -> T
) -> Resolution<T> {
  return { r in
    try initializer(
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve()
    )
  }
}

public func auto<T, A1, A2, A3, A4, A5, A6, A7>(
  _ initializer: @escaping (A1, A2, A3, A4, A5, A6, A7) throws -> T
) -> Resolution<T> {
  return { r in
    try initializer(
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve()
    )
  }
}

public func auto<T, A1, A2, A3, A4, A5, A6, A7, A8>(
  _ initializer: @escaping (A1, A2, A3, A4, A5, A6, A7, A8) throws -> T
) -> Resolution<T> {
  return { r in
    try initializer(
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve()
    )
  }
}

public func auto<T, A1, A2, A3, A4, A5, A6, A7, A8, A9>(
  _ initializer: @escaping (A1, A2, A3, A4, A5, A6, A7, A8, A9) throws -> T
) -> Resolution<T> {
  return { r in
    try initializer(
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve(),
      r.resolve()
    )
  }
}

#endif
