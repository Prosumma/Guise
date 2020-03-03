//
//  Resolve.swift
//  Guise
//
//  Created by Gregory Higley on 3/2/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public typealias Resolve<Arg, Type> = (Resolver, Arg) -> Type
