//
//  AssemblyTests.swift
//  Guise
//
//  Created by Gregory Higley on 3/3/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import XCTest
import Guise

class AssemblyTests: XCTestCase {

  func testAssemblies() {

    final class Logger {
      init() {}
      public func log(_ message: String) {
        print(message)
      }
    }

    struct LoggerAssembly: Assembly {
      func register(in registrar: Registrar & Resolver) {
        registrar.register(singleton: Logger())
      }
    }
    
    struct InnerDependency {
      static let scope: Scope = .registrations / UUID()
      public init(i: Int) {
        
      }
    }
    
    struct InnerAssembly: Assembly {
      static var registrationCount = 0
      func register(in registrar: Registrar & Resolver) {
        registrar.register(assembly: LoggerAssembly())
        registrar.register(in: InnerDependency.scope, factory: construct(InnerDependency.init))
      }
      func registered(to resolver: Resolver) {
        let logger: Logger = resolver.resolve()!
        Self.registrationCount = Self.registrationCount + 1
        logger.log("Registration count: \(Self.registrationCount).")
      }
    }
    
    struct OuterDependency {
      init(innerDependency: InnerDependency) {
        print(innerDependency)
      }
    }
    
    struct OuterAssembly: Assembly {
      func register(in registrar: Registrar & Resolver) {
        registrar.register(assembly: LoggerAssembly())
        registrar.register(assembly: InnerAssembly())
        registrar.register { (r, i: Int) in
          OuterDependency(innerDependency: r.resolve(in: InnerDependency.scope, arg: i)!)
        }
      }
      func registered(to resolver: Resolver) {
        let logger: Logger = resolver.resolve()!
        logger.log("Yeah!")
      }
    }
    
    // We only need to register the outer assembly.
    let container = Container()
    container.register(assembly: OuterAssembly())
    let outerDependency: OuterDependency? = container.resolve(arg: 7)
    XCTAssertNotNil(outerDependency)

    // If we register the inner assembly again, it does nothing.
    // Guise tracks assembly registrations by type.
    container.register(assembly: InnerAssembly())
    XCTAssertEqual(1, InnerAssembly.registrationCount)

    // If we discard the assembly key, we can register it again.
    container.discard(key: .assemblies / InnerAssembly.self)
    container.register(assembly: InnerAssembly())
    XCTAssertEqual(2, InnerAssembly.registrationCount)
  }
    
}
