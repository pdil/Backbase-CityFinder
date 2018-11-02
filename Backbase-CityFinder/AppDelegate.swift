//
//  AppDelegate.swift
//  Backbase-CityFinder
//
//  Created by Paolo Di Lorenzo on 11/1/18.
//  Copyright © 2018 Paolo Di Lorenzo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let citiesFileProvider = FileProvider(fileName: "cities", fileExtension: "json")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = CityListViewController(fileProvider: citiesFileProvider)
        window?.makeKeyAndVisible()
        
        return true
    }

}

