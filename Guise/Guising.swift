//
//  Guising.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public protocol Guising {
    @discardableResult func register<Parameter, RegisteredType>(key: Key<RegisteredType>, metadata: Any, cached: Bool, resolution: @escaping Resolution<Parameter, RegisteredType>) -> Key<RegisteredType>
    @discardableResult func unregister<K: Keyed>(keys: Set<K>) -> Int
    func filter<K: Keyed>(_ filter: @escaping (K) -> Bool) -> [K: Registration]
}

