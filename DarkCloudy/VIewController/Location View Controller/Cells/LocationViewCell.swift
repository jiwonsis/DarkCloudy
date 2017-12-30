//
//  LocationViewCell.swift
//  DarkCloudy
//
//  Created by Scott moon on 30/12/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import UIKit

class LocationViewCell: UITableViewCell {
    
    @IBOutlet weak var mainLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
}

extension LocationViewCell {
    
    func setupView() {
        selectionStyle = .none
    }
    
    static func reuseIdetifier() -> String {
        return "LocationViewCell"
    }
    
    func configureCell(viewModel: LocationRepresentable) {
        mainLabel.text = viewModel.text
    }
}
