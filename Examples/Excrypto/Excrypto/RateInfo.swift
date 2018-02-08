//
//  RateInfo.swift
//  Excrypto
//
//  Created by Gregory Higley on 1/28/18.
//  Copyright © 2018 Prosumma. All rights reserved.
//

import Foundation

struct RateInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case fifteen = "15m"
        case last
        case buy
        case sell
        case symbol
    }
    
    var fifteen: Double
    var last: Double
    var buy: Double
    var sell: Double
    var symbol: String
}
