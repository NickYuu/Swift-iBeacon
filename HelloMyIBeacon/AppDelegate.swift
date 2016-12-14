//
//  AppDelegate.swift
//  HelloMyIBeacon
//
//  Created by YU on 2016/12/14.
//  Copyright © 2016年 YU. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let type: UIUserNotificationType = [.alert, .badge, .sound]
        let settings = UIUserNotificationSettings(types: type, categories: nil)
        application.registerUserNotificationSettings(settings)
        
        return true
    }
    
    
    
}

