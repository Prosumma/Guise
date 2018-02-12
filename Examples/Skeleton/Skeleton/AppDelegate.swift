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
        Guise.register(instance: RemoteApi(logger: Guise.resolve()) as Api)
    }

    func registerDependencies() {
        registerLogger()
        registerApi()
    }
    
    func registerInjections() {
        Guise.into(injectable: Logged.self).inject(\.logger).register()
        Guise.into(injectable: ApiUser.self).inject(\.api).register()
    }
}

