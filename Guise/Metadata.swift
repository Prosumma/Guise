//
//  Metadata.swift
//  Guise
//
//  Created by Gregory Higley on 9/4/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 The type of a metadata predicate.
 */
public typealias Metafilter<M> = (M) -> Bool

/**
 Used in filters and resolution.
 
 This type exists primarily to emphasize that the `metathunk` method should be applied to
 `Metafilter<M>` before the metafilter is passed to the master `filter` or `exists` method.
 */
typealias Metathunk = Metafilter<Any>

func metathunk<M>(_ metafilter: @escaping Metafilter<M>) -> Metathunk {
    return {
        guard let metadata = $0 as? M else { return false }
        return metafilter(metadata)
    }
}

extension Guise {
    
    public static func metadata<K: Keyed, M>(for key: K, type: M.Type = M.self) -> M? {
        let key = AnyKey(key)!
        guard let dependency = lock.read({ registrations[key] }) else { return nil }
        return dependency.metadata as? M
    }
    
}
