//
//  XCTestCase.swift
//  GuiseTests
//
//  Created by Gregory Higley on 2022-09-22.
//

import XCTest
@testable import Guise

extension XCTestCase {
  func prepareForGuiseTests() {
    Entry.allowSynchronousResolutionOfAsyncEntries = false
    Entry.singletonTestDelay = 0
    Entry.testResolutionError = nil
    OptionalResolutionConfig.throwResolutionErrorWhenNotFound = false
    ArrayResolutionConfig.throwResolutionErrorWhenNotFound = false
  }
}
