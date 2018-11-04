//
//  CityViewModel.swift
//  Backbase-CityFinder
//
//  Created by Paolo Di Lorenzo on 11/2/18.
//  Copyright © 2018 Paolo Di Lorenzo. All rights reserved.
//

import UIKit
import CoreLocation

/// View model that encapsulates a `City` object and provides
/// convenient properties and methods for displaying its information.
struct CityViewModel {
    
    /// Reuse identifier for a cell that displays this view model
    static var reuseIdentifier = "cityTableViewCell"
    
    /// City that is represented by this view model
    var city: City
    
    /// Coordinate representation of the city, to be used with CoreLocation or MapKit.
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon)
    }

    /// Flag to be displayed in association with the city
    var displayFlag: String {
        return emojiFlags[city.country] ?? ""
    }
    
    /// Full name of the city, including country abbreviation
    var displayName: String {
        return "\(city.name), \(city.country)"
    }
    
    /// Coordinate representation to be displayed in association with the city
    var displayCoordinates: String {
        // Multiply and divide by 100 while rounding to round to two decimal places
        return "📍(\(round(city.coord.lat * 100) / 100), \(round(city.coord.lon * 100) / 100))"
    }
    
    /// Provides a `UITableViewCell` of type `CityTableViewCell` that is configured with the properties of the city and this view model.
    func configuredCell(for tableView: UITableView, at indexPath: IndexPath) -> CityTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityViewModel.reuseIdentifier, for: indexPath) as! CityTableViewCell
        
        cell.accessoryType = .disclosureIndicator
        cell.flagLabel.text = displayFlag
        cell.cityLabel.text = displayName
        cell.coordsLabel.text = displayCoordinates
        
        return cell
    }
    
}
