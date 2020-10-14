//
//  PropertiesTableViewCell.swift
//  labs-ios-starter
//
//  Created by Bharat Kumar on 10/14/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class PropertiesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
          
        // Initialization code
    }
    
    var property: Property? {
        didSet {
            updateViews()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateViews() {
          guard let property = property else { return }
        self.textLabel?.text = property.name
        self.textLabel?.font = UIFont(name: "Euphemia UCAS", size: 20)
        
        self.detailTextLabel?.text = property.shippingAddress?.address1
      }

}
