//
//  Assembly.swift
//  Guise
//
//  Created by Greg Higley on 2022-09-21.
//

public protocol Assembly {
  func register(in registrar: Registrar)
  func registered(to resolver: Resolver)
}
