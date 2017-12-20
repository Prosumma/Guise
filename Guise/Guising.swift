//
//  Guising.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 The minimal interface for a Guise resolver.
 
 Implement these three methods and you get everything else for free.
 */
public protocol Guising: class {
    @discardableResult func register<ParameterType, HoldingType: Holder>(key: Key<HoldingType.Held>, metadata: Any, cached: Bool, resolution: @escaping Resolution<ParameterType, HoldingType>) -> Key<HoldingType.Held>
    @discardableResult func unregister<Keys: Sequence>(keys: Keys) -> Int where Keys.Element: Keyed
    func filter<K: Keyed>(_ filter: @escaping (K) -> Bool) -> [K: Registration]
}
