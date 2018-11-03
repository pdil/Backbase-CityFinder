//
//  CityViewModel.swift
//  Backbase-CityFinder
//
//  Created by Paolo Di Lorenzo on 11/2/18.
//  Copyright © 2018 Paolo Di Lorenzo. All rights reserved.
//

import CoreLocation

struct CityViewModel {
    
    var city: City
    
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon)
    }
    
    var displayName: String {
        return "\(city.name), \(city.country)"
    }
    
}
