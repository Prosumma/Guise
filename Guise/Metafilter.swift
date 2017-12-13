//
//  Metafilter.swift
//  Guise
//
//  Created by Gregory Higley on 12/12/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public typealias Metafilter<Metadata> = (Metadata) -> Bool

typealias Metathunk<K: Keyed & Hashable, Metadata> = ((Dictionary<K, Registration>.Element) -> Bool)
func metathunk<K: Keyed & Hashable, Metadata>(_ filter: @escaping Metafilter<Metadata>) -> Metathunk<K, Metadata> {
    return {
        guard let metadata = $0.value.metadata as? Metadata else { return false }
        return filter(metadata)
    }
}
