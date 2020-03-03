//
//  Registrar+Discard.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public extension Registrar {
  func discard(_ isDiscarded: @escaping (Registrations.Element) -> Bool) {
    rewrite { registrations in registrations.filter { !isDiscarded($0) } }
  }
  
  func discard(in scope: Scope = .default) {
    discard { $0.key.starts(with: scope) }
  }
  
  func discard(key: Key) {
    discard { $0.key == key }
  }
}
