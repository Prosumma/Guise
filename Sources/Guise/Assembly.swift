//
//  Assembly.swift
//  Guise
//
//  Created by Gregory Higley on 2024-12-24.
//

public protocol Assembly {
  /// Override this method to register dependencies (including child assemblies) in the `Registrar`.
  func register(in registrar: any Registrar)
  /// Optionally override this method to create global instances, etc. when `Assembler::assemble` is called.
  func registered(to resolver: any Resolver) async throws
}

extension Assembly {
  public func registered(to resolver: any Resolver) async throws {}
}
