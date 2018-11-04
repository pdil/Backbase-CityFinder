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
            setToolbarItems([
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(customView: CityCountLabel(count: cityViewModels.count)),
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            ], animated: true)
            
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
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        return searchController
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
        
        setupTableView()
        setupNavigationBar()
        fetchData()
    }
    
    // MARK: - Convenience
    
    /// Configures the table view
    private func setupTableView() {
        tableView.accessibilityIdentifier = "cityListTableView"
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityViewModel.reuseIdentifier)
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()            // remove empty cell separator lines
    }
    
    /// Configures the navigation bar
    private func setupNavigationBar() {
        title = "City Finder"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        navigationController?.isToolbarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingActivityIndicatorView)
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
            tableView.keyboardDismissMode = .onDrag
        }
    }
    
    /// Fetches data from the file provider to be displayed in the table view.
    private func fetchData() {
        func cleanUp() {
            navigationItem.prompt = nil
            loadingActivityIndicatorView.stopAnimating()
        }
        
        loadingActivityIndicatorView.startAnimating()
        navigationItem.prompt = "Loading city data..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                guard let data = try self.fileProvider.contents() else {
                    DispatchQueue.main.async {
                        cleanUp()
                        self.displayError(message: "Data not found.")
                    }
                    
                    return
                }
                
                // Cities are stored in a sorted flat array of view models.
                // This representation allows the creation and filtering of this array to be
                // much simpler and easier, with quick filtering handled by the `CitySearcher` object.
                let decodedCities = try JSONDecoder().decode([City].self, from: data).sorted {
                    // If names are not the same, sort by city name.
                    if $0.name != $1.name {
                        return $0.name < $1.name
                    // otherwise sort by country (if names are the same).
                    } else {
                        return $0.country < $1.country
                    }
                }
                
                DispatchQueue.main.async {
                    cleanUp()
                    self.cityViewModels = decodedCities.map { CityViewModel(city: $0) }
                    self.filteredCityViewModels = self.cityViewModels
                }
            } catch {
                DispatchQueue.main.async {
                    cleanUp()
                    self.displayError(message: error.localizedDescription)
                }
            }
        }
    }
    
    /**
     Displays an error alert to the user as a `UIAlertController`.
     
     - parameter message: The message to be displayed to the user as an error.
    */
    private func displayError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
    /**
     Completion handler called by `CitySearcher` whenever a new search term is provided to it.
     
     - parameter searchTerm: The search term that was used to produce the provided array of cities.
     - parameter cities: The array of cities that match the provided `searchTerm`.
    */
    private func searchResultsUpdated(_ searchTerm: String, _ cities: [City]) {
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
            // `.userInteractive` quality of service is used to provide the most responsive experience
            DispatchQueue.global(qos: .userInteractive).async {
                self.citySearcher?.updateSearch(term: searchText)
            }
        } else {
            self.filteredCityViewModels = self.cityViewModels
        }
    }
}
