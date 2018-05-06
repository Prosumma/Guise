//
//  Registration.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 The type of a registration.
 
 If you implement your own resolver, your registration
 type must implement this protocol.
 */
public protocol Registration {
    var expectsResolver: Bool { get }
    var metadata: Any { get }
    func resolve<RegisteredType>(parameter: Any, cached: Bool?) -> RegisteredType?
}
