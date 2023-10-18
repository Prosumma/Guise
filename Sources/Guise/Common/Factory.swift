//
//  Factory.swift
//  Guise
//
//  Created by Gregory Higley on 2022-10-06.
//

#if swift(>=5.9)
public typealias AsyncFactory<T, each A> = (any Resolver, repeat each A) async throws -> T
public typealias SyncFactory<T, each A> = (any Resolver, repeat each A) throws -> T
#else
public typealias AsyncFactory<T, A> = (any Resolver, A) async throws -> T
public typealias SyncFactory<T, A> = (any Resolver, A) throws -> T
#endif
