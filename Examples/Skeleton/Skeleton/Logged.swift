//
//  Logged.swift
//  Skeleton
//
//  Created by Gregory Higley on 2/12/18.
//  Copyright © 2018 Revolucent LLC. All rights reserved.
//

import Foundation
import XCGLogger

protocol Logged {
    var logger: XCGLogger? { get set }
}
