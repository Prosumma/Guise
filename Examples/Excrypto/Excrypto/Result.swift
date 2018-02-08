//
//  Result.swift
//  Excrypto
//
//  Created by Gregory Higley on 1/28/18.
//  Copyright © 2018 Prosumma. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}

typealias ResultCallback<T> = (Result<T>) -> Void
