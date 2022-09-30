//
//  Resolver+Sync.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

extension Resolver {
  /**
   A helper method for resolving an `Entry`.
   
   Never call `Entry::resolve` directly. Instead, use
   this method, which handles error propagation.
   */
  func resolve<T, A>(
    entry: Entry,
    args arg1: A,
    forKey key: Key
  ) throws -> T {
    do {
      return try entry.resolve(self, arg1) as! T
    } catch let reason as ResolutionError.Reason {
      throw ResolutionError(key: key, reason: reason)
    } catch let error as ResolutionError {
      if error.key == key {
        throw error
      } else {
        throw ResolutionError(key: key, reason: .error(error))
      }
    } catch {
      throw ResolutionError(key: key, reason: .error(error))
    }
  }
}

public extension Resolver {
  /**
   The root resolution method. All roads lead here.
   
   Although this method is public, its overloads are
   much more convenient to use.
   */
  func resolve<T, A>(
    _ type: T.Type = T.self,
    name: Set<AnyHashable>,
    args arg1: A
  ) throws -> T {
    switch type {
    case let type as LazyResolving.Type:
      return type.init(self, name: name, args: arg1) as! T
    default:
      let key = Key(type, tags: name, args: A.self)
      do {
        let entry = try resolve(key: key)
        return try resolve(entry: entry, args: arg1, forKey: key)
      } catch let error as ResolutionError {
        guard
          error.key == key,
          case .notFound = error.reason
        else {
          throw error
        }
        switch type {
        case let type as ResolutionAdapter.Type:
          return try type.resolve(name: name, args: arg1, with: self) as! T
        default:
          throw error
        }
      }
    }
  }

  // Resolve the entry with 0 or 1 arguments.
  func resolve<T, A>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    args arg1: A = ()
  ) throws -> T {
    try resolve(type, name: Set(name), args: arg1)
  }

  /// Resolve the entry with 2 arguments.
  func resolve<T, A1, A2>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    args arg1: A1,
    _    arg2: A2
  ) throws -> T {
    let args = (arg1, arg2)
    return try resolve(type, name: Set(name), args: args)
  }

  /// Resolve the entry with 3 arguments.
  func resolve<T, A1, A2, A3>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    args arg1: A1,
    _    arg2: A2,
    _    arg3: A3
  ) throws -> T {
    let args = (arg1, arg2, arg3)
    return try resolve(type, name: Set(name), args: args)
  }

  /// Resolve the entry with 4 arguments.
  func resolve<T, A1, A2, A3, A4>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    args arg1: A1,
    _    arg2: A2,
    _    arg3: A3,
    _    arg4: A4
  ) throws -> T {
    let args = (arg1, arg2, arg3, arg4)
    return try resolve(type, name: Set(name), args: args)
  }

  /// Resolve the entry with 5 arguments.
  func resolve<T, A1, A2, A3, A4, A5>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    args arg1: A1,
    _    arg2: A2,
    _    arg3: A3,
    _    arg4: A4,
    _    arg5: A5
  ) throws -> T {
    let args = (arg1, arg2, arg3, arg4, arg5)
    return try resolve(type, name: Set(name), args: args)
  }

  /// Resolve the entry with 6 arguments.
  func resolve<T, A1, A2, A3, A4, A5, A6>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    args arg1: A1,
    _    arg2: A2,
    _    arg3: A3,
    _    arg4: A4,
    _    arg5: A5,
    _    arg6: A6
  ) throws -> T {
    let args = (arg1, arg2, arg3, arg4, arg5, arg6)
    return try resolve(type, name: Set(name), args: args)
  }

  /// Resolve the entry with 7 arguments.
  func resolve<T, A1, A2, A3, A4, A5, A6, A7>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    args arg1: A1,
    _    arg2: A2,
    _    arg3: A3,
    _    arg4: A4,
    _    arg5: A5,
    _    arg6: A6,
    _    arg7: A7
  ) throws -> T {
    let args = (arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    return try resolve(type, name: Set(name), args: args)
  }

  /// Resolve the entry with 8 arguments.
  func resolve<T, A1, A2, A3, A4, A5, A6, A7, A8>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    args arg1: A1,
    _    arg2: A2,
    _    arg3: A3,
    _    arg4: A4,
    _    arg5: A5,
    _    arg6: A6,
    _    arg7: A7,
    _    arg8: A8
  ) throws -> T {
    let args = (arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    return try resolve(type, name: Set(name), args: args)
  }

  /// Resolve the entry with 9 arguments.
  func resolve<T, A1, A2, A3, A4, A5, A6, A7, A8, A9>(
    _ type: T.Type = T.self,
    name: AnyHashable...,
    args arg1: A1,
    _    arg2: A2,
    _    arg3: A3,
    _    arg4: A4,
    _    arg5: A5,
    _    arg6: A6,
    _    arg7: A7,
    _    arg8: A8,
    _    arg9: A9
  ) throws -> T {
    let args = (arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return try resolve(type, name: Set(name), args: args)
  }
}
