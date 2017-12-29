//
//  SettingViewCell.swift
//  DarkCloudy
//
//  Created by Scott moon on 30/12/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import UIKit

class SettingViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet var mainLabel: UILabel!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViewController()
    }
    
}

extension SettingViewCell {
    func setupViewController() {
        selectionStyle = .none
    }
    
    static func reuseIdetifier() -> String {
        return "SettingViewCell"
    }
}
