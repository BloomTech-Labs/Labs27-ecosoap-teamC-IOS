//
//  NewPickUpTableViewCell.swift
//  labs-ios-starter
//
//  Created by Bharat Kumar on 10/20/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class NewPickUpTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
        // Initialization code
    }
    
    
    var pickUp: Pickup? {
        didSet {
            updateViews()
        }
    }
     var dateFormatter: DateFormatter?
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func updateViews() {
        guard let pickUp = pickUp else { return }
       if let pickupDate = pickUp.pickupDate, let dateString = dateFormatter?.string(from: pickupDate) {
        textLabel?.text = "Complete on \(dateString)"
        }
    }
    
}
