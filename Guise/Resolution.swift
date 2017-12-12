//
//  Resolution.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 The type of a resolution block.
 
 Guise does not register types or instances directly.
 Instead, it registers resolution blocks, which have
 the type given below.
 
 In most cases, the type of `P` is `Void`, i.e., no
 argument at all, e.g.,
 
 ```
 Guise.register{ SomeDependency() as SomeAbstraction }
 ```
 */
public typealias Resolution<P, R> = (P) -> R
