//
//  Registration.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public protocol Registration {
    var expectsGuising: Bool { get }
    var metadata: Any { get }
    func resolve<RegisteredType>(parameter: Any, cached: Bool?) -> RegisteredType?
}
