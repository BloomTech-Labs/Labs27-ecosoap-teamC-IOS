//
//  ProfileInfoTableViewCell.swift
//  labs-ios-starter
//
//  Created by Wyatt Harrell on 9/9/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ProfileInfoTableViewCell: UITableViewCell, ProfileTextFieldDelegate {
    var profileTextField: String?
    

    @IBOutlet weak var profileTitleLabel: UILabel!
    
    @IBOutlet weak var profileDescriptionTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileDescriptionTextField.text = profileTextField
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  
   
}
