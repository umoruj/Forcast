//
//  AppDelegate.swift
//  forecast
//
//  Created by Jakob Vinther-Larsen on 19/02/2019.
//  Copyright © 2019 SHAPE A/S. All rights reserved.
//

import UIKit
import API

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let client = ForecastClient(appId: "ed4294cefc7170b041d2ba803538d9e0")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = FindLocationConfig.setup(api: client)
        window?.makeKeyAndVisible()
        
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        
        return true
    }

}
