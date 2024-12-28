//
//  Ningleton.swift
//  Guise
//
//  Created by Gregory Higley on 2024-12-18.
//

import Foundation

final class Ningleton: @unchecked Sendable {
  init() {
    Thread.sleep(forTimeInterval: 0.05)
  }
}
