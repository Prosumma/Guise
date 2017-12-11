//
//  Key.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public struct Key<RegisteredType>: Keyed, Hashable {
    public let type = String(reflecting: RegisteredType.self)
    public let name: AnyHashable
    public let container: AnyHashable
    public let hashValue: Int
    
    public init(name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default) {
        self.name = name
        self.container = container
        self.hashValue = hash(self.type, self.name, self.container)
    }
    
    public init?(key: Keyed) {
        self.init(name: key.name, container: key.container)
        if key.type != self.type { return nil }
    }
}


