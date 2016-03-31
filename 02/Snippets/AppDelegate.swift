//
//  AppDelegate.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import UIKit

let components = Components()

@UIApplicationMain
final class AppDelegate: UIResponder {
    var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {
    
    func applicationWillResignActive(application: UIApplication) {
        components.crypto.lock()
        if let c = window?.rootViewController as? RootViewController {
            c.showLockUI()
        }
    }
}
