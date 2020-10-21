//
//  ProfileInfoTableViewCell.swift
//  labs-ios-starter
//
//  Created by Wyatt Harrell on 9/9/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ProfileInfoTableViewCell: UITableViewCell, ProfileTextFieldDelegate, UITextFieldDelegate {
    var profileTextField: String?
    
    weak var detailVC: ProfileViewController?
    
    @IBOutlet weak var profileTitleLabel: UILabel!
    
    @IBOutlet weak var profileDescriptionTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileDescriptionTextField.delegate = self
        profileDescriptionTextField.text = profileTextField
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        detailVC?.profileTextField = (profileDescriptionTextField.text ?? "") + string
        return true 
    }
   
}
