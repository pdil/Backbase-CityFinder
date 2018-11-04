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
        
        cell.forceTap()
        
        XCTAssertTrue(app.navigationBars[testCity].exists)
    }
    
    func testSearchingForCityAndSelectingIt() {
        let app = XCUIApplication()
        
        let testCity = "Albuquerque, US"
        let searchBar = app.searchFields.element
        let tableView = app.tables.containing(.table, identifier: "cityListTableView")
        
        searchBar.tap()
        searchBar.typeText("a")
        XCTAssertEqual(tableView.cells.count, 4)
        searchBar.typeText("l")
        XCTAssertEqual(tableView.cells.count, 2)
        searchBar.typeText("b")
        XCTAssertEqual(tableView.cells.count, 1)
        
        let cell = tableView.cells.staticTexts[testCity]
        cell.forceTap()
        
        let mapNavigationBar = app.navigationBars[testCity]
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

/// Tests that involve tapping on a cell when searching the table view sometimes fail because
/// the search controller transparently obscures the cell (and the cell appears "non-hittable",
/// even though it would be tappable to a normal user.
///
/// The method in this example executes a tap at a specific coordinate if this is the case,
/// which allows the test to progress.
///
/// Adapted from: https://stackoverflow.com/a/33534187/7264964
extension XCUIElement {
    func forceTap() {
        if isHittable {
            tap()
        } else {
            let coordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
            coordinate.tap()
        }
    }
}
