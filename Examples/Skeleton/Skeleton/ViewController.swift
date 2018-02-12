//
//  ViewController.swift
//  Skeleton
//
//  Created by Gregory Higley on 2/12/18.
//  Copyright © 2018 Revolucent LLC. All rights reserved.
//

import Cocoa
import Guise
import XCGLogger

class ViewController: NSViewController, Logged, ApiUser {

    var logger: XCGLogger?
    var api: Api!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         This next line "hydrates" the logger and api
         properties above by referencing the KeyPath
         registrations we made in the AppDelegate.
        */
        Guise.resolve(into: self)
        api.login(username: "Sir", password: "Von") { result in
            switch result {
            case .success(let payload): self.logger?.debug(payload)
            case .error(let error): self.logger?.error(error)
            }
        }
    }

}

