//
//  LazyResolving.swift
//  Guise
//
//  Created by Gregory Higley on 2022-09-21.
//

import Foundation

protocol LazyResolving {
  init<A>(_ resolver: any Resolver, name: Set<AnyHashable>, args: A)
}

