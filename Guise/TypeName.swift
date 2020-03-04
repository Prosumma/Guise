//
//  TypeName.swift
//  Guise
//
//  Created by Gregory Higley on 3/3/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public struct TypeName<Type>: Hashable, CustomStringConvertible, CustomDebugStringConvertible {
  public let type: Type.Type
  
  public var name: String {
    return String(reflecting: type)
  }
  
  public init(_ type: Type.Type = Type.self) {
    self.type = type
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
