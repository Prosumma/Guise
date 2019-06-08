//
//  Injection.swift
//  Guise
//
//  Created by Gregory Higley on 12/12/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/// Type type of an injection.
public typealias Injection<Target> = (Target, Resolving) -> Void
