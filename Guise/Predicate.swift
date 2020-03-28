//
//  Predicate.swift
//  
//
//  Created by Gregory Higley on 3/28/20.
//

import Foundation

public typealias Predicate<T> = (T) -> Bool

public func any<T, Predicates: Sequence>(_ predicates: Predicates) -> Predicate<T> where Predicates.Element == Predicate<T> {
  return { value in
    for predicate in predicates {
      if predicate(value) { return true }
    }
    return false
  }
}

public func any<T>(_ predicates: Predicate<T>...) -> Predicate<T> {
  return any(predicates)
}

public func ||<T>(lhs: @escaping Predicate<T>, rhs: @escaping Predicate<T>) -> Predicate<T> {
  return { value in
    lhs(value) || rhs(value)
  }
}

public func all<T, Predicates: Sequence>(_ predicates: Predicates) -> Predicate<T> where Predicates.Element == Predicate<T> {
  return { value in
    for predicate in predicates {
      if !predicate(value) { return false }
    }
    return true
  }
}

public func all<T>(_ predicates: Predicate<T>...) -> Predicate<T> {
  return all(predicates)
}

public func &&<T>(lhs: @escaping Predicate<T>, rhs: @escaping Predicate<T>) -> Predicate<T> {
  return { value in
    lhs(value) && rhs(value)
  }
}

