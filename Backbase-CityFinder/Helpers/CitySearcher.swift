//
//  CitySearcher.swift
//  Backbase-CityFinder
//
//  Created by Paolo Di Lorenzo on 11/2/18.
//  Copyright © 2018 Paolo Di Lorenzo. All rights reserved.
//

import Foundation

class CitySearcher {
    
    typealias SearchCompletionHandler = (_ searchTerm: String, _ results: [City]) -> ()
    
    // MARK: - Properties
    
    var cities: [City]
    var searchCompletion: SearchCompletionHandler
    
    private var previousSearchText = ""
    private var searchCache = NSCache<NSString, NSArray>()
    
    // MARK: - Initializer
    
    init(cities: [City], searchCompletion: @escaping SearchCompletionHandler) {
        self.cities = cities
        self.searchCompletion = searchCompletion
    }
    
    // MARK: - Search
    
    func updateSearch(text: String) {
        let filteredCities: [City]
        
        if text.count > previousSearchText.count {
            // Active search text is longer than previous search text, indicating that the user added a character to the search.
            // In this case, we can filter from the previously cached search (if it exists) instead of the entire array.
            if let cached = searchCache.object(forKey: previousSearchText as NSString), let cachedFilteredCities = cached as? [City] {
                filteredCities = filter(cachedFilteredCities, matching: text)
            } else {
                filteredCities = filter(cities, matching: text)
            }
        } else {
            // Active search text is shorter than previous search text, indicating that the user deleted a character from the search.
            // In this case, we can filter using the search text as the results should hopefully be located in the cache.
            if let cached = searchCache.object(forKey: text as NSString), let cachedFilteredCities = cached as? [City] {
                filteredCities = cachedFilteredCities
            } else {
                filteredCities = filter(cities, matching: text)
            }
        }
        
        searchCache.setObject(filteredCities as NSArray, forKey: text as NSString)
        
        searchCompletion(text, filteredCities)
        
        // Prepare for the next time the search text is updated
        previousSearchText = text
    }
    
    private func filter(_ cities: [City], matching searchText: String) -> [City] {
        return cities.filter {
            $0.name.lowercased().hasPrefix(searchText.lowercased())
        }
    }

}
