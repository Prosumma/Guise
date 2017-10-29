//
//  Guise.swift
//  Guise
//
//  Created by Gregory Higley on 9/3/17.
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
 
 - note: Instances of this type cannot be created. Use its static methods.
 */
public struct Guise {
    /**
     `Name.default` is used when no name is specified for registration and resolution.
     
     Registrations made specifically with `Name.default` or made without specifying a name
     are said to have the default name.
     */
    public enum Name {
        /**
         `Name.default` is used when no name is specified for registration and resolution.
         
         Registrations made specifically with `Name.default` or made without specifying a name
         are said to have the default name.
         */
        case `default`
    }
    
    /**
     `Container.default` is used when no container is specified for registration and resolution.
     
     Registrations made specifically in `Container.default` or made without specifying a container
     are said to live in the default container.
     */
    public enum Container {
        /**
         `Container.default` is used when no container is specified for registration and resolution.
         
         Registrations made specifically in `Container.default` or made without specifying a container
         are said to live in the default container.
         */
        case `default`
    }
    
    static let defaultResolver = Resolver()
    
    // Instance of this type cannot be created.
    private init() {}

    /// Returns all registered keys
    public static var keys: Set<AnyKey> {
        return Set(defaultResolver.keys)
    }
}
