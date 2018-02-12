//
//  Api.swift
//  Skeleton
//
//  Created by Gregory Higley on 2/12/18.
//  Copyright © 2018 Revolucent LLC. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}

protocol Api {
    func call<R: Decodable>(endpoint: String, payload: Data, callback: @escaping (Result<R>) -> Void)
}

enum LoginResult: String, Decodable {
    case authorized
    case unauthorized
}

struct Credentials: Encodable {
    let username: String
    let password: String
}

extension Api {
    func call<R: Decodable>(endpoint: String, payload: Data = Data(), callback: @escaping (Result<R>) -> Void) {
        call(endpoint: endpoint, payload: payload, callback: callback)
    }
    
    func call<P: Encodable, R: Decodable>(endpoint: String, payload: P, callback: @escaping (Result<R>) -> Void) {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(payload)
        call(endpoint: endpoint, payload: data, callback: callback)
    }
    
    func login(username: String, password: String, callback: @escaping (Result<LoginResult>) -> Void) {
        let credentials = Credentials(username: username, password: password)
        call(endpoint: "login", payload: credentials, callback: callback)
    }
}
