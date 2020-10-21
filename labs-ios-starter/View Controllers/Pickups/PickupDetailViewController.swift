//
//  PickupDetailViewController.swift
//  labs-ios-starter
//
//  Created by Wyatt Harrell on 9/23/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class PickupDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var propertyNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var driverLabel: UILabel!
    @IBOutlet weak var soapLabel: UILabel!
     @IBOutlet weak var paperLabel: UILabel!
     @IBOutlet weak var linensLabel: UILabel!
     @IBOutlet weak var bottleLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!

    // MARK: - Properties
    var controller = BackendController.shared
    var pickup: Pickup? {
        didSet {
            setupViews()
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

    }
    
    // MARK: - Private Methods
    private func setupViews() {
        guard let pickup = pickup else { return }
        guard let property = controller.properties[pickup.propertyId] else { return }
        locationLabel?.text = property.shippingAddress?.address1
        let dateString = pickup.pickupDate?.asShortDateString()
        dateLabel?.text = dateString
        let timeString = pickup.readyDate.asShortDateString()
        timeLabel?.text = timeString
        driverLabel?.text = "Pending"
        
        soapLabel?.text = "\(property.impact?.soapRecycled)"
        paperLabel?.text = "\(property.impact?.paperRecycled)"
        linensLabel?.text = "\(property.impact?.linensRecycled)"
        bottleLabel?.text =  "\(property.impact?.linensRecycled)"
        notesLabel?.text = pickup.notes
        
//        let property = controller?.properties[pickup.propertyId]
//        propertyNameLabel.text = property?.name
        
        /*
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false

        for id in pickup.cartonsById {
            let carton = controller?.pickupCartons[id]

            let view = UIView()
            view.backgroundColor = UIColor(named: "Panel System Background")
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 40).isActive = true

            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            if carton?.product = "" {
                imageView.image = UIImage(named: "")
            }
            imageView.contentMode = .scaleAspectFit

            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text =

        }
        */
    }
    
    private func updateViews() {
        
    }
    @IBAction func editButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "editPickupSegue", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPickupSegue" {
            guard let pickupDetailsVC = segue.destination as? SchedulePickupViewController else { return }
            pickupDetailsVC.pickup = pickup
            pickupDetailsVC.hideIt = true 
            pickupDetailsVC.controller = controller
        }
    }
    
    // MARK: - IBActions


}
