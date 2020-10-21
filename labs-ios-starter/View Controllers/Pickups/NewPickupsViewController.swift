//
//  NewPickupsViewController.swift
//  labs-ios-starter
//
//  Created by Bharat Kumar on 10/20/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class NewPickupsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var oldPickTableView: UITableView!
    
    @IBOutlet weak var noticeLabel: UILabel!
    var controller = BackendController.shared
    
    var pickups: [Pickup] = []
    let dateFormatter = DateFormatter()
    private var pickUpData: [[String]]?
    override func viewDidLoad() {
        super.viewDidLoad()
        for pickup in pickups {
            guard let pickupDate = pickup.pickupDate else { return }
            
            noticeLabel.text = "Your next pickups is on \(pickupDate.asShortDateString())"
        }
        grabPickups()
        setupViews()
        //
        //        for pickupid in controller.pickups.values {
        //            controller.pickupsByPropertyId(propertyId: pickupid.propertyId ) { error in
        //                self.grabPickups()
        //                if let error = error {
        //                    NSLog("Error in getting pickups: \(error)")
        //                    return
        //                }
        //                DispatchQueue.main.async {
        //                    self.tableView.reloadData()
        //
        //                }
        //            }
        //
        //        }
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func scedulePickUpTapped(_ sender: UIButton) {
    performSegue(withIdentifier: "newPickupSegue", sender: self)
    }
    
    private func setupViews() {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.calendar = .current
    }
    private func grabPickups() {
        for pickup in controller.pickups.values {
            pickups.append(pickup)
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "pickUpDetailSegue" {
            guard let pickupDetailsVC = segue.destination as? PickupDetailViewController else { return }
            pickupDetailsVC.controller = controller
            
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
            pickupDetailsVC.pickup = pickups[selectedIndexPath.row]
        }
    }
    
    
}

extension NewPickupsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pickups.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newPickupCell", for: indexPath) as? NewPickUpTableViewCell else { return UITableViewCell() }
        
        let pickup = pickups[indexPath.row]
        
        cell.pickup = pickup
        cell.detailVC = self 
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    
}
