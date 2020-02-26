//
//  VoidContainer.swift
//  Guise
//
//  Created by Gregory Higley on 2/26/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public class VoidContainer: Registrar & Resolver {
  public init() {}

  public subscript(key: Key) -> Registration? {
    get { return nil }
    set { }
  }

  public func filter(where predicate: (RegistrationEntry) -> Bool) -> [RegistrationEntry] {
    return []
  }
}
