//
//  CityTableViewCell.swift
//  Backbase-CityFinder
//
//  Created by Paolo Di Lorenzo on 11/3/18.
//  Copyright © 2018 Paolo Di Lorenzo. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    private let padding: CGFloat = 16

    // MARK: - Subviews
    
    var flagLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 48)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var cityLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        return label
    }()
    
    var coordsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Setup
    
    private func setupViews() {
        contentView.addSubview(flagLabel)
        flagLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
        flagLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
        if #available(iOS 11.0, *) {
            flagLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: padding).isActive = true
        } else {
            flagLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
        }
        
        contentView.addSubview(cityLabel)
        cityLabel.leadingAnchor.constraint(equalTo: flagLabel.trailingAnchor, constant: padding).isActive = true
        cityLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -padding).isActive = true
        cityLabel.centerYAnchor.constraint(equalTo: flagLabel.centerYAnchor).isActive = true
        
        contentView.addSubview(coordsLabel)
        coordsLabel.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor).isActive = true
        coordsLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor).isActive = true
    }
    
}
