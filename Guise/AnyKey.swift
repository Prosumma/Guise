//
//  AnyKey.swift
//  Guise
//
//  Created by Gregory Higley on 12/11/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public struct AnyKey: Keyed, Hashable {
    public let type: String
    public let name: AnyHashable
    public let container: AnyHashable
    public let hashValue: Int
    
    public init<T>(type: T.Type, name: AnyHashable = Guise.Name.default, container: AnyHashable = Guise.Container.default) {
        self.type = String(reflecting: type)
        self.name = name
        self.container = container
        self.hashValue = hash(self.type, self.name, self.container)
    }
    
    public init?(_ key: Keyed) {
        self.type = key.type
        self.name = key.name
        self.container = key.container
        self.hashValue = hash(self.type, self.name, self.container)
    }
}
