//
//  Backbase_CityFinderUITests.swift
//  Backbase-CityFinderUITests
//
//  Created by Paolo Di Lorenzo on 11/1/18.
//  Copyright © 2018 Paolo Di Lorenzo. All rights reserved.
//

import XCTest

class Backbase_CityFinderUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchArguments.append("integration_test")
        app.launchEnvironment["test_file_name"] = "test_cities"
        app.launch()
    }

    func testSelectingCityAndDisplayingMap() {
        let app = XCUIApplication()
    
        let testCity = "Anaheim, US"
        let cell = app.tables.containing(.table, identifier: "cityListTableView").cells.staticTexts[testCity]
        
        cell.tap()
        
        XCTAssertTrue(app.navigationBars[testCity].exists)
    }
    
    func testSearchingForCityAndSelectingIt() {
        let app = XCUIApplication()
        
        let searchBar = app.searchFields.element
        let tableView = app.tables.containing(.table, identifier: "cityListTableView")
        
        searchBar.tap()
        searchBar.typeText("a")
        XCTAssertEqual(tableView.cells.count, 4)
        searchBar.typeText("l")
        XCTAssertEqual(tableView.cells.count, 2)
        searchBar.typeText("b")
        XCTAssertEqual(tableView.cells.count, 1)
        
        let cell = tableView.cells.staticTexts["Albuquerque, US"]
        cell.tap()
        
        let mapNavigationBar = app.navigationBars["Albuquerque, US"]
        XCTAssertTrue(mapNavigationBar.exists)
        
        // Tap back button in navigation bar to go back to city list
        mapNavigationBar.buttons.element(boundBy: 0).tap()
        // Tap clear button in search bar
        searchBar.buttons.element(boundBy: 0).tap()
        
        XCTAssertEqual(tableView.cells.count, 6)
    }
    
    func testErrorAlertIsDisplayed() {
        // Load non-existent file to see if an error is correctly displayed.
        let app = XCUIApplication()
        app.launchArguments.append("integration_test")
        app.launchEnvironment["test_file_name"] = "test_cities_error"   // This file does not exist
        app.launch()
        
        let alert = app.alerts.staticTexts["Error"]
        
        XCTAssertTrue(alert.exists)
    }

}
