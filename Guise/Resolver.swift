//
//  Resolver.swift
//  Guise
//
//  Created by Gregory Higley on 2/25/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public typealias RegistrationEntry = (key: Key, value: Registration)

public protocol Resolver {
  subscript(key: Key) -> Registration? { get }
  func filter(where predicate: (RegistrationEntry) -> Bool) -> [RegistrationEntry]
}

