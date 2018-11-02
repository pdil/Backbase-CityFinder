//
//  CityListViewController.swift
//  Backbase-CityFinder
//
//  Created by Paolo Di Lorenzo on 11/1/18.
//  Copyright © 2018 Paolo Di Lorenzo. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController {

    private var fileProvider: FileProvider
    
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
        
        do {
            guard let data = try fileProvider.contents() else {
                fatalError("Data not found.")
            }
            
            let cities = try JSONDecoder().decode([City].self, from: data)
            print(cities.count)
        } catch {
            print(error.localizedDescription)
        }
    }


}

