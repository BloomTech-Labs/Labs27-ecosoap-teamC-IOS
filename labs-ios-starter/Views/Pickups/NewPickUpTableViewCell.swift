//
//  NewPickUpTableViewCell.swift
//  labs-ios-starter
//
//  Created by Bharat Kumar on 10/20/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class NewPickUpTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
        // Initialization code
    }
    weak var detailVC: NewPickupsViewController?
    
    var pickup: Pickup? {
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
         guard let pickup = pickup else { return }
      if pickup.status == "COMPLETE" {
                  statusLabel.text = "Complete"
        statusLabel.textColor = UIColor(named: .colorESBGreen)
              } else if pickup.status == "OUT_FOR_PICKUP" {
                  statusLabel.text = "Out for Pickup"
        statusLabel.textColor = UIColor(ciColor: .yellow)
              } else if pickup.status == "CANCELLED" {
                  statusLabel.text = "Canceled"
                  statusLabel.textColor = UIColor(named: .colorESBRed)
                  
              } else if pickup.status == "SUBMITTED" {
                  statusLabel.text = "Sumbitted"
             statusLabel.textColor = UIColor(named: .colorESBGreen)
                
              }
        print(pickup.pickupDate)
        let dateString1 = pickup.pickupDate?.asShortDateString()
        descriptionLabel.text = dateString1
        
    }
    
}
