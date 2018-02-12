//
//  ImpotentResolver.swift
//  Guise
//
//  Created by Gregory Higley on 12/12/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public final class ImpotentResolver: Resolving {
    @discardableResult public func register<ParameterType, HoldingType: Holder>(key: Key<HoldingType.Held>, metadata: Any, cached: Bool, resolution: @escaping Resolution<ParameterType, HoldingType>) -> Key<HoldingType.Held> {
        return key
    }
    
    @discardableResult public func unregister<Keys: Sequence>(keys: Keys) -> Int where Keys.Element: Keyed {
        return 0
    }

    public func filter<K: Keyed>(_ filter: @escaping (K) -> Bool) -> [K: Registration] {
        return [:]
    }
    
    public var injectables: Set<String> {
        return []
    }

    public func register(injectable: String, injection: @escaping (Any, Resolving) -> Any) -> String {
        return injectable
    }
    
    public func resolve<Target>(into target: Target) -> Target {
        return target
    }
    
    public func unregister<Keys>(keys: Keys) -> Int where Keys : Sequence, Keys.Element == String {
        return 0
    }

}
