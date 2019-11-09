//
//  WeatherDataCell.swift
//  WeatherDemo
//
//  Created by Mike Pollard on 26/10/2019.
//  Copyright © 2019 Mike Pollard. All rights reserved.
//

import UIKit

class WeatherDataCell: UITableViewCell {
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var dataTrailing: NSLayoutConstraint!
    
    func setup(data: WeatherDataPacket) {
        self.lblDescription.text = data.title.rawValue
        self.lblData.text = data.data
        
        if let icon = data.icon, let image = UIImage(named: icon) {
            self.ivIcon.image = image
        }
        
        if self.ivIcon.image != nil {
            self.dataTrailing.constant += self.ivIcon.frame.width
        }
    }
    
    override func prepareForReuse() {
        self.lblDescription.text = nil
        self.lblData.text = nil
        self.ivIcon.image = nil
        self.dataTrailing.constant = 0.0
    }
}
