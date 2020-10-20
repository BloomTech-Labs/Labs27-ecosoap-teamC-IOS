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
    
    private var pickUp: Pickup? {
        didSet {
            updateViews()
        }
    }
    private var pickUpData: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        newPickTableView.delegate = self
        newPickTableView.dataSource = self
        
        oldPickTableView.delegate = self
        oldPickTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    private func updateViews() {
        guard let pickUp = pickUp else { return }
        for property in controller.properties.values {
            controller.pickupsByPropertyId(propertyId: property.id) { error in
                if let error = error {
                    NSLog("Error in getting the pickups dates: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    print("pickups fetched succesfully")
                    self.newPickTableView.reloadData()
                    self.oldPickTableView.reloadData()
                }
            }
        }
        pickUpData.append(pickUp.pickupDate?.asShortDateString() ?? "")
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
        return pickUpData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == newPickTableView,
            let cell = tableView.dequeueReusableCell(withIdentifier: "newPickupCell") {
            cell.textLabel?.text = pickUpData[indexPath.row]
            return cell
        }
            return UITableViewCell()
        }
    }

