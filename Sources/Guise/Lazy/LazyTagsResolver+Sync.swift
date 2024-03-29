//
//  LazyTagsResolver+Sync.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-29.
//

#if swift(<5.9)

public extension LazyTagsResolver {
  func resolve<A1, A2>(
    args arg1: A1, _ arg2: A2
  ) throws -> T {
    try resolve(args: (arg1, arg2))
  }

  func resolve<A1, A2, A3>(
    args arg1: A1, _ arg2: A2, _ arg3: A3
  ) throws -> T {
    try resolve(args: (arg1, arg2, arg3))
  }

  func resolve<A1, A2, A3, A4>(
    args arg1: A1, _ arg2: A2, _ arg3: A3, _ arg4: A4
  ) throws -> T {
    try resolve(args: (arg1, arg2, arg3, arg4))
  }

  func resolve<A1, A2, A3, A4, A5>(
    args arg1: A1, _ arg2: A2, _ arg3: A3, _ arg4: A4, _ arg5: A5
  ) throws -> T {
    try resolve(args: (arg1, arg2, arg3, arg4, arg5))
  }

  func resolve<A1, A2, A3, A4, A5, A6>(
    args arg1: A1, _ arg2: A2, _ arg3: A3, _ arg4: A4, _ arg5: A5, _ arg6: A6
  ) throws -> T {
    try resolve(args: (arg1, arg2, arg3, arg4, arg5, arg6))
  }

  func resolve<A1, A2, A3, A4, A5, A6, A7>(
    args arg1: A1, _ arg2: A2, _ arg3: A3, _ arg4: A4, _ arg5: A5, _ arg6: A6, _ arg7: A7
  ) throws -> T {
    try resolve(args: (arg1, arg2, arg3, arg4, arg5, arg6, arg7))
  }

  func resolve<A1, A2, A3, A4, A5, A6, A7, A8>(
    args arg1: A1, _ arg2: A2, _ arg3: A3, _ arg4: A4, _ arg5: A5, _ arg6: A6, _ arg7: A7, _ arg8: A8
  ) throws -> T {
    try resolve(args: (arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8))
  }

  func resolve<A1, A2, A3, A4, A5, A6, A7, A8, A9>(
    args arg1: A1, _ arg2: A2, _ arg3: A3, _ arg4: A4, _ arg5: A5, _ arg6: A6, _ arg7: A7, _ arg8: A8, _ arg9: A9
  ) throws -> T {
    try resolve(args: (arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9))
  }
}

#endif
