//
//  City.swift
//  Backbase-CityFinder
//
//  Created by Paolo Di Lorenzo on 11/1/18.
//  Copyright © 2018 Paolo Di Lorenzo. All rights reserved.
//

/// Structure representing a city, loading from cities.json
struct City: Decodable, Equatable {
    var country: String
    var name: String
    var id: Int
    var coord: Coord
    
    private enum CodingKeys: String, CodingKey {
        case country, name, id = "_id", coord
    }
}

/// Structure representing a set of coordinates for a city
struct Coord: Decodable, Equatable {
    var lon: Double
    var lat: Double
}
