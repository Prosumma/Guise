//
//  AppDelegate.swift
//  Skeleton
//
//  Created by Gregory Higley on 2/12/18.
//  Copyright © 2018 Revolucent LLC. All rights reserved.
//

import Cocoa
import Guise
import XCGLogger

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    override init() {
        super.init()
        registerDependencies()
        registerInjections()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // MARK: Guise
    
    func registerLogger() {
        let logger = XCGLogger.default
        logger.setup(level: .debug, showLogIdentifier: true, showFunctionName: true, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: nil, fileLevel: nil)
        Guise.register(instance: logger)
    }
    
    func registerApi() {
        /*
         Why do we register RemoteApi as Api? Because in our unit tests we
         probably don't want to use the REAL api which talks to a server.
         We want to use a fake one. (Of course, in this app, our "real" API
         is just as fake.)
         
         By abstracting with a protocol, we can use any conforming Api implementation,
         with or without Guise.
         
         This means that when we get an instance of Api out of Guise, we must say…
         
         Guise.resolve(type: Api.self)
         
         and NOT
         
         Guise.resolve(type: RemoteApi.self)
         
         As far as Guise is concerned, there is no RemoteApi registered. Only Api.
         
         We also have here an example of Init Injection. (This is often called Constructor
         Injection in other languages.) Elsewhere we have registered a logger, and
         when Guise creates an Api instance for us (by calling Guise.resolve(type: Api.self)),
         it will also resolve the logger and pass it to the initalizer of RemoteApi.
        */
        Guise.register(instance: RemoteApi(logger: Guise.resolve()) as Api)
    }

    func registerDependencies() {
        registerLogger()
        registerApi()
    }
    
    func registerInjections() {
        /*
         Injections are a way to "pass" dependencies to instances
         which are already created by Apple's frameworks. For instance,
         in general we do not create view controllers. They are created
         for us.
         
         So how do we get our dependencies into them? By registering KeyPath
         injections such as those below. The first line says, "There is an
         protocol called Logged. Register an injection of its logger property
         which is of type XCGLogger?. Resolve this injection by looking
         up the registration of XCGLogger in the resolver and assigning
         it to the logger property of any Logged instance.
         
         Resolution of KeyPath injection occurs when Guise.resolve(into: self)
         is called inside the view controller's viewDidLoad. To see an
         example, go to the ViewController class in this project.
        */
        Guise.into(injectable: Logged.self).inject(\.logger).register()
        Guise.into(injectable: ApiUser.self).inject(\.api).register()
    }
}

