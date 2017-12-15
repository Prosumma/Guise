//
//  Holder.swift
//  Guise
//
//  Created by Gregory Higley on 12/15/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

public protocol Holder {
    associatedtype Held
    var value: Held? { get }
    static var cached: Bool? { get }
}

public extension Holder {
    static var cached: Bool? {
        return nil
    }
}
