//
//  CityCountLabel.swift
//  Backbase-CityFinder
//
//  Created by Paolo Di Lorenzo on 11/3/18.
//  Copyright © 2018 Paolo Di Lorenzo. All rights reserved.
//

import UIKit

class CityCountLabel: UILabel {

    // MARK: - Properties
    
    private var count: Int
    
    // MARK: - Initializer
    
    init(count: Int) {
        self.count = count
        super.init(frame: .zero)
        
        backgroundColor = .clear
        font = .boldSystemFont(ofSize: 14)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if let formattedCount = formatter.string(from: NSNumber(value: count)) {
            text = "Displaying \(formattedCount) cities"
        }
        
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
