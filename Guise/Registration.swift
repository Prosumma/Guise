//
//  Registration.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public protocol Registration {
  var metadata: Any { get }
  func resolve<Type>(type: Type.Type, arg: Any) -> Type
}

