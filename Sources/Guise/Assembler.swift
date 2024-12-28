//
//  Assembler.swift
//  Guise
//
//  Created by Gregory Higley on 2024-12-25.
//

public protocol Assembler {
  /**
   Prepares each `Assembly` and its dependent assemblies for use.
   
   In practice, this means each assembly in the list is first registered
   and then, in order of registration, `registered(to:)` is called.
   
   After this method is called, the internal ordered set of assemblies
   is emptied.
   
   The implementation of this method in `Container` is not thread-safe.
   It's best to call it only once very early in the application lifecycle.
   */
  func assemble<each A: Assembly>(_ assemblies: repeat each A) async throws
}
