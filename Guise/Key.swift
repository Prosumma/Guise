//
//  Key.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

/**
 A `Key` is a `Scope` used directly as an entry in the DI container.
 
 The difference is mostly contextual. A `Key` is just a `Scope`. However,
 a `Key` typically has a `Type` as its last element, e.g.,

 ```
 let scope: Scope = .default / "blah"
 let key = scope / String.self
 ```
 */
public typealias Key = Scope
