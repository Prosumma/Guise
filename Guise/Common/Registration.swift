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
    /// Whether or not the parameter of `resolve` should be the resolver itself.
    var expectsResolver: Bool { get }
    /// The registered metadata
    var metadata: Any { get }
    /// Performs the actual resolution
    func resolve<RegisteredType>(parameter: Any, cached: Bool?) -> RegisteredType?
}
