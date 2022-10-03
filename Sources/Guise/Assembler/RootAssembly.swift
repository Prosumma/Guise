//
//  RootAssembly.swift
//  Guise
//
//  Created by Greg Higley on 2022-10-02.
//

public final class RootAssembly: Assembly {
  public let dependentAssemblies: [Assembly]

  public init(_ assemblies: [any Assembly]) {
    dependentAssemblies = assemblies
  }

  public convenience init(_ assemblies: any Assembly...) {
    self.init(assemblies)
  }
}
