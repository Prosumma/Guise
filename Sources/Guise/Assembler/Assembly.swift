//
//  Assembly.swift
//  Guise
//
//  Created by Greg Higley on 2022-09-21.
//

public protocol Assembly {
  var dependentAssemblies: [any Assembly] { get }
  func register(in registrar: any Registrar)
  func registered(to resolver: any Resolver)
}

public extension Assembly {
  var dependentAssemblies: [any Assembly] { [] }
  func register(in registrar: any Registrar) {}
  func registered(to resolver: any Resolver) {}
}
