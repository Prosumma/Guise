//
//  Lock.swift
//  Guise
//
//  Created by Gregory Higley on 9/3/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/// A simple GCD-powered lock allowing one writer and multiple readers.
final class Lock {

    private let label = "com.prosumma.Guise.lock"
    private let queue: DispatchQueue
    
    init() {
        let qos: DispatchQoS
        if #available(macOS 10.10, *) {
            /*
             We're fibbing a bit here, but the docs say that .userInteractive indicates
             work that completes instantaneously and immediately. This precisely
             characterizes what we lock with this lock: We do key lookups and that's it.
             Resolution and metadata filtering are always performed outside of the lock.
             */
            qos = .userInteractive
        } else {
            qos = .unspecified
        }
        let afq: DispatchQueue.AutoreleaseFrequency
        if #available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            afq = .workItem
        } else {
            afq = .inherit
        }
        queue = DispatchQueue(label: label, qos: qos, attributes: .concurrent, autoreleaseFrequency: afq, target: nil)
    }
    
    func read<T>(_ block: () -> T) -> T {
        var result: T! = nil
        queue.sync {
            result = block()
        }
        return result
    }
    
    func write<T>(_ block: () -> T) -> T {
        var result: T! = nil
        queue.sync(flags: .barrier) {
            result = block()
        }
        return result
    }
    
}
