//
//  Util.swift
//  
//
//  Created by Gregory Higley on 3/23/20.
//

import Foundation

func not<Arg>(_ predicate: @escaping (Arg) -> Bool) -> (Arg) -> Bool {
  return { !predicate($0) }
}
