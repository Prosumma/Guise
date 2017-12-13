//
//  _Guise.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public protocol _Guise {
    static var defaultResolver: Guising { get set }
    @discardableResult static func register<Parameter, RegisteredType>(key: Key<RegisteredType>, metadata: Any, cached: Bool, resolution: @escaping Resolution<Parameter, RegisteredType>) -> Key<RegisteredType>
    @discardableResult static func unregister<Keys: Sequence>(keys: Keys) -> Int where Keys.Element: Keyed
    static func filter<K: Keyed>(_ filter: @escaping (K) -> Bool) -> [K: Registration]
}

