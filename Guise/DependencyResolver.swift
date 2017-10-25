//
//  DependencyResolver.swift
//  Guise
//
//  Created by Gregory Higley on 10/24/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 Guise is a simple dependency resolution framework.
 
 Guise does not register types or instances directly. Instead,
 it registers a resolution block which returns the needed dependency.
 Guise manages a thread-safe dictionary mapping keys to resolution
 blocks.
 
 The key with which each dependency is associated consists of the
 return type of the resolution block, a `Hashable` name, and a `Hashable`
 container. If no name is specified, it defaults to `Guise.Name.default`
 and is said to have the default name. If no container is specified,
 it defaults to `Guise.Container.default` and is said to live in the
 default container.
 
 In addition, it is common to alias the return type of the resolution
 block using a protocol to achieve abstraction.
 
 This simple, flexible system can accommodate many scenarios. Some of
 these scenarios are so common that overloads exist to handle them
 concisely.
 */
public class DependencyResolver {
    
    var lock = Lock()
    var registrations = [AnyKey: Registration]()
    
    /// Returns all registered keys
    public var keys: Set<AnyKey> {
        return Set(registrations.keys)
    }
    
}
