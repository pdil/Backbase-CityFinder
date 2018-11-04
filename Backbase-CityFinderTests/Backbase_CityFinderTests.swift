//
//  Backbase_CityFinderTests.swift
//  Backbase-CityFinderTests
//
//  Created by Paolo Di Lorenzo on 11/1/18.
//  Copyright © 2018 Paolo Di Lorenzo. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Backbase_CityFinder

class Backbase_CityFinderTests: XCTestCase {
    
    var testCity: City!
    var testCitiesArray: [City]!

    override func setUp() {
        testCity = City(country: "US", name: "Alabama", id: 1, coord: Coord(lon: 0, lat: 0))
        testCitiesArray = [
            City(country: "US", name: "Alabama", id: 1, coord: Coord(lon: 0, lat: 0)),
            City(country: "US", name: "Albuquerque", id: 2, coord: Coord(lon: 0, lat: 0)),
            City(country: "US", name: "Anaheim", id: 3, coord: Coord(lon: 0, lat: 0)),
            City(country: "US", name: "Arizona", id: 4, coord: Coord(lon: 0, lat: 0)),
            City(country: "CA", name: "Sydney", id: 5, coord: Coord(lon: 0, lat: 0)),
            City(country: "AU", name: "Sydney", id: 6, coord: Coord(lon: 0, lat: 0))
        ]
    }

    func testCityViewModel() {
        let cityViewModel = CityViewModel(city: testCity)
        let testCityCoordinates = CLLocationCoordinate2D(latitude: testCity.coord.lat, longitude: testCity.coord.lon)
        XCTAssertEqual(testCityCoordinates.latitude, cityViewModel.coordinates.latitude)
        XCTAssertEqual(testCityCoordinates.longitude, cityViewModel.coordinates.longitude)
        
        // Test view model creates correct strings for display
        
        XCTAssertEqual("\(testCity.name), \(testCity.country)", cityViewModel.displayName)
        XCTAssertEqual(emojiFlags[testCity.country], cityViewModel.displayFlag)
        XCTAssertEqual("📍(\(round(testCity.coord.lat * 100) / 100), \(round(testCity.coord.lon * 100) / 100))", cityViewModel.displayCoordinates)
        
        // Test view model provides correct cell configuration
        
        let tableView = UITableView()
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityViewModel.reuseIdentifier)
        
        let cell = cityViewModel.configuredCell(for: tableView, at: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cell.cityLabel.text, cityViewModel.displayName)
        XCTAssertEqual(cell.flagLabel.text, cityViewModel.displayFlag)
        XCTAssertEqual(cell.coordsLabel.text, cityViewModel.displayCoordinates)
        XCTAssertEqual(cell.accessoryType, .disclosureIndicator)
    }
    
    func testCityLoading() {
        let fileProvider = FileProvider(fileName: "test_cities", fileExtension: "json", bundle: MockBundle())
        
        XCTAssertNoThrow(try fileProvider.contents())
        XCTAssertNotNil(try fileProvider.contents())
        
        do {
            // force unwrapping (!) because we already tested that the contents do not throw an error and are not nil
            let contents = try! fileProvider.contents()!
            let decodedContents = try JSONDecoder().decode([City].self, from: contents)
            
            XCTAssertEqual(decodedContents, testCitiesArray)
        } catch {
            XCTFail("An error occurred while decoding: \(error.localizedDescription)")
        }
    }
    
    func testCitySearch() {
        let citySearcher = CitySearcher(cities: testCitiesArray) { searchTerm, cities in
            switch searchTerm {
            case "a":
                XCTAssertEqual(cities.map { $0.name }, ["Alabama", "Albuquerque", "Anaheim", "Arizona"])
            case "al":
                XCTAssertEqual(cities.map { $0.name }, ["Alabama", "Albuquerque"])
            case "alb":
                XCTAssertEqual(cities.map { $0.name }, ["Albuquerque"])
            case "s":
                XCTAssertEqual(cities.map { $0.name }, ["Sydney", "Sydney"])
            default:
                break
            }
        }
        
        citySearcher.updateSearch(text: "a")
        citySearcher.updateSearch(text: "al")
        citySearcher.updateSearch(text: "alb")
        
        // Test deleting of characters to see if cache works.
        citySearcher.updateSearch(text: "al")
        citySearcher.updateSearch(text: "a")
        
        citySearcher.updateSearch(text: "s")
    }
    
    func testCitySearchIsNotCaseSensitive() {
        let citySearcher = CitySearcher(cities: testCitiesArray) { searchTerm, cities in
            switch searchTerm {
            case "a":
                XCTAssertEqual(cities.map { $0.name }, ["Alabama", "Albuquerque", "Anaheim", "Arizona"])
            case "al":
                XCTAssertEqual(cities.map { $0.name }, ["Alabama", "Albuquerque"])
            case "alb":
                XCTAssertEqual(cities.map { $0.name }, ["Albuquerque"])
            case "s":
                XCTAssertEqual(cities.map { $0.name }, ["Sydney", "Sydney"])
            default:
                break
            }
        }
        
        citySearcher.updateSearch(text: "a")
        citySearcher.updateSearch(text: "aL")
        citySearcher.updateSearch(text: "Alb")
        citySearcher.updateSearch(text: "s")
    }

}
