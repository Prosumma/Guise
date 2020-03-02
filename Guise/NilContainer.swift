//
//  NilContainer.swift
//  Guise
//
//  Created by Gregory Higley on 3/2/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public class NilContainer: Registrar & Resolver {

  public subscript(key: Key) -> Any? {
    get { nil }
    set { }
  }

  public func filter(_ isIncluded: (Registrations.Element) -> Bool) -> Registrations {
    return [:]
  }

  public func rewrite(_ write: @escaping (Registrations) -> Registrations) {

  }
}
