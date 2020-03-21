//
//  Resolver.swift
//  Guise
//
//  Created by Gregory Higley on 3/1/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public typealias Entries = [Key: Any]

public protocol Resolver {
  subscript(key: Key) -> Any? { get }
  func read() -> Entries
}

