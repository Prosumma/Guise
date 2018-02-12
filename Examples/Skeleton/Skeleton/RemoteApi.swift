//
//  RemoteApi.swift
//  Skeleton
//
//  Created by Gregory Higley on 2/12/18.
//  Copyright © 2018 Revolucent LLC. All rights reserved.
//

import Foundation
import XCGLogger

enum ApiError: Error {
    case unknownEndpoint
}

struct RemoteApi: Api {
    
    private let logger: XCGLogger?
    
    init(logger: XCGLogger? = nil) {
        self.logger = logger
    }
    
    func call<R: Decodable>(endpoint: String, payload: Data, callback: @escaping (Result<R>) -> Void) {
        logger?.debug(endpoint)
        // We're just gonna fake it.
        switch endpoint {
        case "login": callback(.success(LoginResult.authorized as! R))
        default: callback(.error(ApiError.unknownEndpoint))
        }
    }
}
