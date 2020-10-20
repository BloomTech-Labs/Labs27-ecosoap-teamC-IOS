//
//  NewPickupsViewController.swift
//  labs-ios-starter
//
//  Created by Bharat Kumar on 10/20/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class NewPickupsViewController: UIViewController {

    @IBOutlet weak var newPickTableView: UITableView!
    @IBOutlet weak var oldPickTableView: UITableView!
    
    var controller = BackendController.shared
    
    var pickUps: [Pickup] = []
    let dateFormatter = DateFormatter()
    private var pickUpData: [[String]]?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        grabPickups()
        for pickup in pickUps {
            controller.pickupsByPropertyId(propertyId: pickup.propertyId) { error in
                self.grabPickups()
                if let error = error {
                    NSLog("Error in getting pickups: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    self.newPickTableView.reloadData()
                }
            }
        }
        newPickTableView.delegate = self
        newPickTableView.dataSource = self
        
        oldPickTableView.delegate = self
        oldPickTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    private func updateViews() {
      
   
    }
    private func grabPickups() {
        
        var pickupDates: [String] = []
        for pickup in controller.pickups.values {
            guard let pickupDate = pickup.pickupDate else { return }
            let dateString = dateFormatter.string(from: pickupDate)
            pickupDates.append(dateString)
            pickUps.append(pickup)
            
        }
        let data: [[String]] = [pickupDates]
        pickUpData = data
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewPickupsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickUps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == newPickTableView,
            let cell = tableView.dequeueReusableCell(withIdentifier: "newPickupCell") as? NewPickUpTableViewCell {
            self.grabPickups()
            let pickUp = pickUps[indexPath.row]
            cell.dateFormatter = dateFormatter
            cell.pickUp = pickUp
            return cell
        }
            return UITableViewCell()
        }
    }

