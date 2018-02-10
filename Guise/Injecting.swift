//
//  Injecting.swift
//  Guise
//
//  Created by Gregory Higley on 2/10/18.
//  Copyright © 2018 Gregory Higley. All rights reserved.
//

import Foundation

protocol Injecting: class {
    var inject: Injection<Any>? { get set }
}
