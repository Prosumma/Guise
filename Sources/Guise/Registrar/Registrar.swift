//
//  Registrar.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-20.
//

import Foundation

public protocol Registrar {
  func register(key: Key, entry: Entry)
  func unregister(keys: Set<Key>)
  func register<A: Assembly>(assembly: A)
}
