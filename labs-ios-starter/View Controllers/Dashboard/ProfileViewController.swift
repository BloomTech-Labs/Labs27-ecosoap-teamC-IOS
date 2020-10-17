//
//  ProfileViewController.swift
//  labs-ios-starter
//
//  Created by Wyatt Harrell on 9/2/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private let accountInfoLabels = ["Name",
                               "Company",
                               "Address",
                                "Phone",
                                "Email",
                                "Skype"]
    private let contactInfoLabels = ["Phone",
                                     "Email",
                                     "Skype"]

    private let placeholderData = ["John Doe",
                                   "Hilton Worldwide Holdings Inc.",
                                   "250 Forbes Ave"]
    private let placeholderData2 = ["345-594-9034",
                                   "example@gmail.com",
                                    "jdoe"]
    
    var controller = BackendController.shared
    var profileData: [String] = []
    var userProfile: User? {
        didSet {
            updateViews()
        }
    }
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userProfile = userProfile else { return }
        controller.userById(id: controller.loggedInUser.id) { error in
            if let error = error {
                NSLog("Error in fetching the user: \(error)")
                return
            }
          
            self.controller.loggedInUser = userProfile
              
                print(self.controller.loggedInUser)
            
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            updateViews()
        }
    
   
    private func updateViews() {
        
            profileData.append("\(controller.loggedInUser.firstName)")
            profileData.append(controller.loggedInUser.company ?? "")
            profileData.append(controller.loggedInUser.address?.address1 ?? "")
            profileData.append(controller.loggedInUser.phone ?? "")
            profileData.append(controller.loggedInUser.email)
            profileData.append(controller.loggedInUser.skype ?? "")
        

    }
    
 
    
    private func fetchAll() {
          controller.initialFetch(userId: controller.loggedInUser.id) { (error) in
              if let error = error {
                  NSLog("\(error): Error occured during initial fetch")
              }
              if let user = self.controller.users[self.controller.loggedInUser.id] {
                  self.controller.loggedInUser = user
                
                  print(self.controller.loggedInUser)
              }
              print("\(self.controller.users)")
              print("\(self.controller.properties)")
              print("\(self.controller.pickups)")
              //            print("\(self.controller.payments)")
              print("\(self.controller.hubs)")
              print("\(self.controller.pickupCartons)")
              print("\(self.controller.hospitalityContracts)")
              
          }
      }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountInfoLabels.count
    }
    
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "Account Info"
//        } else {
//            return "Contact Info"
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell", for: indexPath) as? ProfileInfoTableViewCell else { return UITableViewCell() }
        cell.profileTitleLabel.text = accountInfoLabels[indexPath.row].uppercased()
        cell.profileDescriptionTextField.text = profileData[indexPath.row]
        
        return cell
    }
}
