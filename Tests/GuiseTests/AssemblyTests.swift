//
//  AssemblyTests.swift
//  Guise
//
//  Created by Gregory Higley on 2024-12-25.
//

import Guise
import Testing

@Test func testAssembly() async throws {
  let container = Container()
  try await container.assemble(TestAssembly(), TestAssembly())
  let house: House = try await container.resolve()
  #expect(house.thing.x == 55)
}
