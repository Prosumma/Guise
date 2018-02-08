//
//  Api.swift
//  Excrypto
//
//  Created by Gregory Higley on 1/28/18.
//  Copyright © 2018 Prosumma. All rights reserved.
//

import Foundation

protocol ApiServicing {
    func call<T: Decodable>(callback: ResultCallback<T>)
}

final class Api: ApiServicing {
    func call<T: Decodable>(callback: (Result<T>) -> Void) {
        
    }
}

extension ApiServicing {
    func ticker(callback: (Result<[String: RateInfo]>) -> Void) {
        call(callback: callback)
    }
}
