//
//  CityViewModel.swift
//  Backbase-CityFinder
//
//  Created by Paolo Di Lorenzo on 11/2/18.
//  Copyright © 2018 Paolo Di Lorenzo. All rights reserved.
//

import UIKit
import CoreLocation

struct CityViewModel {
    
    static var reuseIdentifier = "cityTableViewCell"
    
    var city: City
    
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon)
    }
    
    var displayFlag: String {
        return emojiFlags[city.country] ?? ""
    }
    
    var displayName: String {
        return "\(city.name), \(city.country)"
    }
    
    var displayCoordinates: String {
        // Multiply and divide by 100 while rounding to round to two decimal places
        return "(\(round(city.coord.lat * 100) / 100), \(round(city.coord.lon * 100) / 100))"
    }
    
    func configuredCell(for tableView: UITableView, at indexPath: IndexPath) -> CityTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityViewModel.reuseIdentifier, for: indexPath) as! CityTableViewCell
        
        cell.flagLabel.text = displayFlag
        cell.cityLabel.text = displayName
        cell.coordsLabel.text = displayCoordinates
        
        return cell
    }
    
}
