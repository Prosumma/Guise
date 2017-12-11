//
//  Resolver.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public class Resolver {
    private var lock = Lock()
    private var registrations = [AnyKey: Registration]()
    
    func register<Parameter, RegisteredType>(key: Key<RegisteredType>, metadata: Any, cached: Bool, resolution: @escaping Resolution<Parameter, RegisteredType>) -> Key<RegisteredType> {
        return key
    }
    
    func unregister<Keys: Sequence>(keys: Keys) -> Int where Keys.Element: Keyed {
        return 0
    }
    
    func filter<K: Keyed>(key: K.Type, name: AnyHashable?, container: AnyHashable?) -> [K: Registration] {
        return [:]
    }
}
