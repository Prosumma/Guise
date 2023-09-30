//
//  Factory.swift
//  Guise
//
//  Created by Gregory Higley on 2022-10-06.
//

public typealias AsyncFactory<T, A> = (any Resolver, A) async throws -> T
public typealias SyncFactory<T, A> = (any Resolver, A) throws -> T