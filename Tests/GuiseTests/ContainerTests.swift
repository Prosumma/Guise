//
//  ContainerTests.swift
//  Guise
//
//  Created by Gregory Higley on 2024-12-22.
//

import Guise
import Testing

@Test func testResolveInParent() throws {
  let parent = Container()
  parent.register(instance: Thing(x: 77))
  let child = Container(parent: parent)
  _ = try child.resolve(Thing.self)
}

@Test func testChildRegistrationOverridesParent() throws {
  let parent = Container()
  parent.register(instance: Thing(x: 77))
  let child = Container(parent: parent)
  child.register(instance: Thing(x: 99))
  let thing = try child.resolve(Thing.self)
  #expect(thing.x == 99)
}
