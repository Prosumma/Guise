//
//  Filtering.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Guising {
    
    func filter<K: Keyed & Hashable>(key: K) -> Registration? {
        return filter(key: K.self, name: key.name, container: key.container).values.first
    }
    
}

public extension _Guise {

    static func filter<K: Keyed & Hashable>(key: K) -> Registration? {
        return filter(key: K.self, name: key.name, container: key.container).values.first
    }
    
}
