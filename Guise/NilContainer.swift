//
//  NilContainer.swift
//  Guise
//
//  Created by Gregory Higley on 3/2/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

/**
 A container which does nothing. Useful in testing.
 */
public class NilContainer: Registrar & Resolver {

  public subscript(key: Key) -> Any? {
    get { nil }
    set { }
  }
  
  public func makeIterator() -> AnyIterator<Dictionary<Key, Any>.Element> {
    AnyIterator([:].makeIterator())
  }

  public func write(_ setter: (Registrations) -> Registrations) {
    
  }

  public func rewrite(_ write: @escaping (Registrations) -> Registrations) {

  }
  
  public var builder: FactoryBuilder {
    FactoryBuilder(registrar: self)
  }
}
