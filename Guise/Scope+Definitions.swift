//
//  Scope+Definitions.swift
//  Guise
//
//  Created by Gregory Higley on 3/2/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public extension Scope {
  static let registrations = Scope(Registration.self)
  static let `default` = Scope.registrations / "$default$"
  static let injections = Scope(Injection.self)
}
