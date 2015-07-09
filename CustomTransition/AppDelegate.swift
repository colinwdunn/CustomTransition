//
//  AppDelegate.swift
//  CustomTransition
//
//  Created by Colin Dunn on 3/14/15.
//  Copyright (c) 2015 Colin Dunn. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = UIColor.whiteColor()
        
        window?.rootViewController = ViewController()
        
        window!.makeKeyAndVisible()
        return true
    }
    
}