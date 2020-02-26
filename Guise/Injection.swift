//
//  Injection.swift
//  Guise
//
//  Created by Gregory Higley on 2/26/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public final class Injection: RegistrationBase {
  private let injection: (Resolver, AnyObject) -> Void

  public init<Type: AnyObject>(inject: @escaping (Resolver, Type) -> Void) {
    injection = { (r, o) in inject(r, o as! Type) }
    super.init(metadata: ())
  }

  public override func inject(resolver: Resolver, into target: AnyObject) {
    injection(resolver, target)
  }
}
