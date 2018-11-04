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
        let citiesFileProvider: FileProvider
        
        // If an integration (UI) test is running, load test data instead of using full dataset.
        // The test data contains a short amount of cities for faster loading and predictable behavior.
        if ProcessInfo.processInfo.arguments.contains("integration_test") {
            let fileName = ProcessInfo.processInfo.environment["test_file_name"] ?? "test_cities"
            citiesFileProvider = FileProvider(fileName: fileName, fileExtension: "json")
        } else {
            citiesFileProvider = FileProvider(fileName: "cities", fileExtension: "json")
        }
        
        // Setup the window and initial view controller
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: CityTableViewController(fileProvider: citiesFileProvider))
        window?.makeKeyAndVisible()
        
        return true
    }

}

