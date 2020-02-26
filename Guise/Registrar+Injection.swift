//
//  Registrar+Injection.swift
//  Guise
//
//  Created by Gregory Higley on 2/26/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public extension Registrar {
  func into<Target: AnyObject>(target: Target.Type) -> Injector<Target> {
    return Injector(self)
  }
}
