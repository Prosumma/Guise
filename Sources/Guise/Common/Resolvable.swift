//
//  Resolvable.swift
//  Guise
//
//  Created by Gregory Higley on 2022-10-06.
//

public protocol Resolvable {
  var lifetime: Lifetime { get }
  func resolve(_ resolver: any Resolver, _ argument: Any) throws -> Any
  func resolve(_ resolver: any Resolver, _ argument: Any) async throws -> Any
}
