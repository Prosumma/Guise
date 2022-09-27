//
//  Lifetime.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

public enum Lifetime {
  /**
   An instance of the dependency is returned
   each time it is resolved.
   */
  case transient
  /**
   The same instance of the dependency is
   returned every time it resolved.
   */
  case singleton
}
