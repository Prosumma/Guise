//
//  Injection.swift
//  Guise
//
//  Created by Gregory Higley on 2/26/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public final class Injection: RegistrationBase {
  private let injection: (Resolver, AnyObject, [AnyHashable: Any]) -> Void

  public init<Type: AnyObject>(inject: @escaping (Resolver, Type, [AnyHashable: Any]) -> Void) {
    injection = { (r, o, args) in inject(r, o as! Type, args) }
    super.init(metadata: ())
  }

  public override func inject(resolver: Resolver, into target: AnyObject, args: [AnyHashable: Any]) {
    injection(resolver, target, args)
  }
}
