//
//  Singleton.swift
//  Guise
//
//  Created by Gregory Higley on 2024-12-18.
//

actor Singleton {
  init() async throws {
    try await Task.sleep(nanoseconds: 5_000)
  }
}
