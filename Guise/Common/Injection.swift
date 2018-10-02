//
//  Injection.swift
//  Guise
//
//  Created by Gregory Higley on 12/12/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 The type of an injection.
 
 If `Target` is a reference type, an Injection block *must*
 return the *same* reference.
 */
public typealias Injection<Target> = (Target, Resolving) -> Void
