//
//  Metadata.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public extension Resolving {
    /**
     Returns the metadata associated with given key, if it is type-compatible
     with `Metadata` as determined by Swift's `as?` operator. If the metadata
     does not exist or if it is not of type `Metadata`, `nil` is returned.
     
     ```
     if let metadata = Guise.metadata(for: key, metatype: Int.self),
        metadata > 3 {
        print("Found metadata > 3!")
     }
     ```
     */
    func metadata<RegisteredType, Metadata>(for key: Key<RegisteredType>, metatype: Metadata.Type = Metadata.self) -> Metadata? {
        guard let registration: Registration = filter(key: key) else { return nil }
        return registration.metadata as? Metadata
    }
}

public extension _Guise {
    /**
     Returns the metadata associated with given key, if it is type-compatible
     with `Metadata` as determined by Swift's `as?` operator. If the metadata
     does not exist or if it is not of type `Metadata`, `nil` is returned.
     
     ```
     if let metadata = Guise.metadata(for: key, metatype: Int.self),
         metadata > 3 {
         print("Found metadata > 3!")
     }
     ```
     */
    static func metadata<RegisteredType, Metadata>(for key: Key<RegisteredType>, metatype: Metadata.Type = Metadata.self) -> Metadata? {
        return resolver.metadata(for: key, metatype: metatype)
    }
}
