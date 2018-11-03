//
//  CityTableViewController.swift
//  Backbase-CityFinder
//
//  Created by Paolo Di Lorenzo on 11/1/18.
//  Copyright © 2018 Paolo Di Lorenzo. All rights reserved.
//

import UIKit

class CityTableViewController: UITableViewController {

    // MARK: - Properties
    
    private var fileProvider: FileProvider
    private var citySearcher: CitySearcher?
    
    private var cityViewModels = [CityViewModel]() {
        didSet {
            citySearcher = CitySearcher(cities: cityViewModels.map { $0.city }, searchCompletion: searchResultsUpdated)
        }
    }
    
    private var filteredCityViewModels = [CityViewModel]() {
        didSet {
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
    
    // MARK: - Subviews
    
    private var loadingActivityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .gray)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
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
        
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityViewModel.reuseIdentifier)
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        
        setupNavigationBar()
        fetchData()
    }
    
    // MARK: - Convenience
    
    private func setupNavigationBar() {
        title = "City Finder"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        navigationController?.isToolbarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingActivityIndicatorView)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    private func fetchData() {
        loadingActivityIndicatorView.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                guard let data = try self.fileProvider.contents() else {
                    DispatchQueue.main.async {
                        self.displayError(message: "Data not found.")
                    }
                    
                    return
                }
                
                let decodedCities = try JSONDecoder().decode([City].self, from: data).sorted {
                    // If names are not the same, sort by city name.
                    if $0.name != $1.name {
                        return $0.name < $1.name
                    // otherwise sort by country (if names are the same).
                    } else {
                        return $0.country < $1.country
                    }
                }
                
                self.cityViewModels = decodedCities.map { CityViewModel(city: $0) }
                self.filteredCityViewModels = self.cityViewModels
                
                DispatchQueue.main.async {
                    self.loadingActivityIndicatorView.stopAnimating()
                }
            } catch {
                DispatchQueue.main.async {
                    self.displayError(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func displayError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
    private func searchResultsUpdated(_ cities: [City]) {
        filteredCityViewModels = cities.map { CityViewModel(city: $0) }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = filteredCityViewModels[indexPath.row]
        let mapViewController = MapViewController(city: selectedCity)
        
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCityViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return filteredCityViewModels[indexPath.row].configuredCell(for: tableView, at: indexPath)
    }

}

// MARK: - UISearchResultsUpdating
extension CityTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            DispatchQueue.global(qos: .userInteractive).async {
                self.citySearcher?.updateSearch(text: searchText)
            }
        } else {
            self.filteredCityViewModels = self.cityViewModels
        }
    }
}
