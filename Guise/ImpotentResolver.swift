//
//  ImpotentResolver.swift
//  Guise
//
//  Created by Gregory Higley on 12/12/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public struct ImpotentResolver: Guising {
    @discardableResult public func register<RegisteredType, ParameterType, HoldingType: Holder>(key: Key<RegisteredType>, metadata: Any, cached: Bool, resolution: @escaping Resolution<ParameterType, HoldingType>) -> Key<RegisteredType> where HoldingType.Held == RegisteredType {
        return key
    }
    
    @discardableResult public func unregister<Keys: Sequence>(keys: Keys) -> Int where Keys.Element: Keyed {
        return 0
    }

    public func filter<K: Keyed>(_ filter: @escaping (K) -> Bool) -> [K: Registration] {
        return [:]
    }
}
