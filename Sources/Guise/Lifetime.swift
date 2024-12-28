//
//  Lifetime.swift
//  Guise
//
//  Created by Gregory Higley on 2024-11-05.
//

import Foundation

public enum Lifetime: Sendable {
  /// Represents a singleton lifetime, where a single instance is created and shared.
  case singleton
  /// Represents a transient lifetime for a dependency.
  /// 
  /// A transient lifetime means that a new instance of the dependency
  /// will be created each time it is requested.
  case transient
}
