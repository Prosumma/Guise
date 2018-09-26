//
//  InjectableTableViewController.swift
//  Guise
//
//  Created by Gregory Higley on 9/25/18.
//  Copyright © 2018 Gregory Higley. All rights reserved.
//

import UIKit

/**
 A simple `UITableViewController` subclass that supports injection.
 
 Example:
 
 ```
 protocol ApiCalling {
    var api: Api! { get set }
 }
 
 class AppDelegate {
    override init() {
        super.init()
        Guise.register(instance: ApiCaller() as Api)
        Guise.into(injectable: ApiCalling.self).inject(\.api).register()
    }
 }
 
 class MainViewController: InjectableTableViewController, ApiCalling {
     var api: Api!
     override func viewDidLoad() {
        super.viewDidLoad()
        // At this point, `api` can be used.
     }
 }
 ```
 
 - note: This class uses `Guise.resolve(into:)` in order to
 resolve the dependencies. If you are using your own `Resolver`
 instance, you should not use this class, though it should
 be relatively straightforward to roll your own.
 */
open class InjectableTableViewController: UITableViewController {

    override open func viewDidLoad() {
        super.viewDidLoad()
        Guise.resolve(into: self)
    }

}
