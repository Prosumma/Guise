//
//  Metadata.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Guising {
    func metadata<RegisteredType, Metadata>(for key: Key<RegisteredType>, type: Metadata.Type = Metadata.self) -> Metadata? {
        guard let registration: Registration = filter(key: key) else { return nil }
        return registration.metadata as? Metadata
    }
}

public extension _Guise {
    static func metadata<RegisteredType, Metadata>(for key: Key<RegisteredType>, type: Metadata.Type = Metadata.self) -> Metadata? {
        return defaultResolver.metadata(for: key, type: type)
    }
}
