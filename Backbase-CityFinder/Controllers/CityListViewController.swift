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

    // MARK: - Properties
    
    private var fileProvider: FileProvider
    
    private var cityViewModels = [CityViewModel]()
    
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CityListViewController.reuseIdentifier)
        
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
                
                let decodedCities = try JSONDecoder().decode([City].self, from: data).sorted { $0.name < $1.name }
                self.cityViewModels = decodedCities.map { CityViewModel(city: $0) }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cityViewModels[indexPath.row]
        let mapViewController = MapViewController(city: selectedCity)
        
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityListViewController.reuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = cityViewModels[indexPath.row].displayName
        
        return cell
    }


}

