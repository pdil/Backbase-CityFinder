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
    
    /**
     Consumes a search term and produces a filtered array of cities based on the search term.
     Once the cities have been filtered according to the search term, the caller is notified
     using the `SearchCompletionHandler` provided to the receiver in the initializer.
     
     This method also caches each search term and intelligently decides whether or not to use
     the previously used search term (or the current one) in retrieving filtered items from the cache.
     
     The caching technique results in much faster and responsive execution of searching and filtering when
     the user is quickly typing into a search field.
     
     - parameter term: The search term to apply for filtering.
    */
    func updateSearch(term: String) {
        let filteredCities: [City]
        
        if term.count > previousSearchText.count {
            // Active search text is longer than previous search text, indicating that the user added a character to the search.
            // In this case, we can filter from the previously cached search (if it exists) instead of the entire array.
            if let cached = searchCache.object(forKey: previousSearchText as NSString), let cachedFilteredCities = cached as? [City] {
                filteredCities = filter(cachedFilteredCities, matching: term)
            } else {
                filteredCities = filter(cities, matching: term)
            }
        } else {
            // Active search text is shorter than previous search text, indicating that the user deleted a character from the search.
            // In this case, we can filter using the search text as the results should hopefully be located in the cache.
            if let cached = searchCache.object(forKey: term as NSString), let cachedFilteredCities = cached as? [City] {
                filteredCities = cachedFilteredCities
            } else {
                filteredCities = filter(cities, matching: term)
            }
        }
        
        // Cache the search results associated with the current search text
        // for faster retrieval next time the same search term is used.
        searchCache.setObject(filteredCities as NSArray, forKey: term as NSString)
        
        // Notify the caller of the resulting items
        searchCompletion(term, filteredCities)
        
        // Prepare for the next time the search text is updated
        previousSearchText = term
    }
    
    /**
     Convenience method that filters an array of cities in a case insensitive way.
     Both the city names and the search terms are converted to lowercase.
     
     - parameter cities: The array of cities to filter.
     - parameter searchTerm: The search term to use for filtering.
     
     - returns: The filtered array of cities.
    */
    private func filter(_ cities: [City], matching searchTerm: String) -> [City] {
        return cities.filter {
            $0.name.lowercased().hasPrefix(searchTerm.lowercased())
        }
    }

}
