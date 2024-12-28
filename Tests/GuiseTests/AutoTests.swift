//
//  AutoTests.swift
//  Guise
//
//  Created by Gregory Higley on 2024-12-18.
//

import Guise
import Testing

@Test func testAuto_sync() throws {
  let container = Container()
  container.register(instance: Thing(x: 99))
  container.register(factory: auto(House.init))
  let house: House = try container.resolve()
  #expect(house.thing.x == 99)
}

@Test func testAuto_async() async throws {
  let container = Container()
  container.register { _ in await Alien(s: "something") }
  container.register(factory: auto(Spaceship.init))
  let spaceship: Spaceship = try await container.resolve()
  #expect(spaceship.alien.s == "something")
}
