//
//  CityListViewController.swift
//  Backbase-CityFinder
//
//  Created by Paolo Di Lorenzo on 11/1/18.
//  Copyright © 2018 Paolo Di Lorenzo. All rights reserved.
//

import UIKit

class CityListViewController: UITableViewController {
    
    private static var reuseIdentifier = "cityListTableViewCell"

    private var fileProvider: FileProvider
    
    private var cities = [CityViewModel]()
    
    // MARK: - Initializer
    
    init(fileProvider: FileProvider) {
        self.fileProvider = fileProvider
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CityListViewController.reuseIdentifier)
        
        title = "City Finder"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        navigationController?.isToolbarHidden = false
        
        do {
            guard let data = try fileProvider.contents() else {
                fatalError("Data not found.")
            }
            
            let decodedCities = try JSONDecoder().decode([City].self, from: data).sorted { $0.name < $1.name }
            cities = decodedCities.map { CityViewModel(city: $0) }
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        
        let mapViewController = MapViewController(city: selectedCity)
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityListViewController.reuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = cities[indexPath.row].displayName
        
        return cell
    }


}

