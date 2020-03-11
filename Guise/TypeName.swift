//
//  TypeName.swift
//  Guise
//
//  Created by Gregory Higley on 3/3/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

/**
 Holds a type as a `Hashable` value.

 Why not just use a `String`? Because then there would be no way to distinguish the following:

 ```
 let scope = .default / "Swift.String"
 let scope = .default / String.self
 ```

 The latter uses `TypeName<String>` under the hood.
 */
public struct TypeName<Type>: Hashable, CustomStringConvertible, CustomDebugStringConvertible {
  public let name: String
  
  public var type: Type.Type {
    Type.self
  }
  
  public init(_ type: Type.Type = Type.self) {
    name = String(reflecting: type)
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(name)
  }
  
  public var description: String {
    return name
  }
  
  public var debugDescription: String {
    return name.debugDescription
  }
  
  public static func ==(lhs: TypeName<Type>, rhs: TypeName<Type>) -> Bool {
    true
  }
}
