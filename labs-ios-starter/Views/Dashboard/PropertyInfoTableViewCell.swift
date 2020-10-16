//
//  PropertyInfoTableViewCell.swift
//  labs-ios-starter
//
//  Created by Wyatt Harrell on 9/14/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class PropertyInfoTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    var wasEdited = false
    weak var detailVC: PropertyDetailViewController?
    static var delegate = PropertyInfoTableViewCell()
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        // Configure the view for the selected state
    }
    
  

}
