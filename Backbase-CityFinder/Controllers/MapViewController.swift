//
//  MapViewController.swift
//  Backbase-CityFinder
//
//  Created by Paolo Di Lorenzo on 11/2/18.
//  Copyright © 2018 Paolo Di Lorenzo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    /// Size of centered map view in meters
    private let mapRegionSize: CLLocationDistance = 4000
    
    // MARK: - Properties
    
    var city: CityViewModel
    
    // MARK: - Subviews
    
    private var mapView: MKMapView?
    
    // MARK: - Initializer
    
    init(city: CityViewModel) {
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = city.displayName
        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Center Map on City", style: .plain, target: self, action: #selector(centerMap)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]
        
        setupMapView()
        centerMap()
    }
    
    // MARK: - Convenience
    
    private func setupMapView() {
        mapView = MKMapView()
        guard let mapView = mapView else { return }
        
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc private func centerMap() {
        let region = MKCoordinateRegion(center: city.coordinates, latitudinalMeters: mapRegionSize, longitudinalMeters: mapRegionSize)
        mapView?.setRegion(region, animated: true)
    }

}
