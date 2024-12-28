//
//  LazyResolving.swift
//  Guise
//
//  Created by Gregory Higley on 2024-11-07.
//

public protocol LazyResolving {
  init(tagset: Set<AnySendableHashable>, with resolver: any Resolver)
}
