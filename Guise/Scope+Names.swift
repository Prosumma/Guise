//
//  Scope+Names.swift
//  Guise
//
//  Created by Gregory Higley on 3/2/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public extension Scope {
  /// The root scope for registrations.
  static let factories = Scope(Registration.self)
  /// The default scope for registrations. When no scope is specified, this is what you get.
  static let `default` = Scope.factories / "$default$"
  /// The scope for injections.
  static let injections = Scope(Injection.self)
  /// The scope for assembly registrations.
  static let assemblies = Scope(Assembly.self)
}
