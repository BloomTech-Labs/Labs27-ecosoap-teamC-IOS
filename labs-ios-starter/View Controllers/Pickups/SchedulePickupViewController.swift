//
//  SchedulePickupViewController.swift
//  labs-ios-starter
//
//  Created by Wyatt Harrell on 8/11/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class SchedulePickupViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var schedulePickupButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var selectDriverText: UITextField!
    @IBOutlet weak var soapTextField: UITextField!
    @IBOutlet weak var paperTextField: UITextField!
    @IBOutlet weak var linensTextField: UITextField!
    @IBOutlet weak var bottlesTextField: UITextField!
    @IBOutlet weak var orderNotesTextField: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    // MARK: - Properties
    private var cartons: [Int] = [-1]
    
    private var soapCartons: [UUID:Int] = [:]
    private var paperCartons: [UUID:Int] = [:]
    private var linenCartons: [UUID:Int] = [:]
    private var bottleCartons: [UUID:Int] = [:]
    var hideIt = false
    // Pickup Input Properties
    private var notes: String?
    private var selectedProperty: Property?
    private var pickupDate: Date?
    var controller = BackendController.shared
    var pickup: Pickup? {
        didSet {
            updateViews()
        }
    }
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateViews()
        hideitAll()
    }
    func hideitAll() {
        if hideIt == true {
            schedulePickupButton.isHidden = true
        }
    }
    // MARK: - Private Methods
    private func setupViews() {
        self.hideKeyboardWhenViewTapped()
        schedulePickupButton.layer.cornerRadius = 8
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
    
    private func updateViews() {
        guard let pickup = pickup else { return }
        guard let property = controller.properties[pickup.propertyId] else { return }
        locationTextField?.text = property.shippingAddress?.address1
        let dateString = pickup.pickupDate?.asShortDateString()
        dateTextField?.text = dateString
        timeTextField?.text = dateString
        selectDriverText?.text = "pending"
        soapTextField?.text = "\(property.impact?.soapRecycled)"
        paperTextField?.text = "\(property.impact?.paperRecycled)"
        linensTextField?.text = "\(property.impact?.linensRecycled)"
        bottlesTextField?.text = "\(property.impact?.bottlesRecycled)"
        orderNotesTextField?.text = pickup.notes
    }
    
    
    
    // MARK: - IBActions
    @IBAction func schedulePickupButtonTapped(_ sender: Any) {
        guard let pickUp = pickup else { return }
        var cartons: [CartonInput] = []
        for percentage in soapCartons.values {
            cartons.append(CartonInput(product: .SOAP, percentFull: percentage))
        }
        soapTextField.text = "\(cartons[0].percentFull)"
        
        for percentage in paperCartons.values {
            cartons.append(CartonInput(product: .PAPER, percentFull: percentage))
        }
        paperTextField.text = "\(cartons[1].percentFull)"
        
        for percentage in linenCartons.values {
            cartons.append(CartonInput(product: .LINENS, percentFull: percentage))
        }
        linensTextField.text = "\(cartons[2].percentFull)"
        
        for percentage in bottleCartons.values {
            cartons.append(CartonInput(product: .BOTTLES, percentFull: percentage))
        }
        bottlesTextField.text = "\(cartons[3].percentFull)"
        guard let notesText = orderNotesTextField.text else { return }
        
        let pickupInput = PickupInput(collectionType: .LOCAL, status: .SUBMITTED, readyDate: Date(), propertyId: pickUp.propertyId , cartons: cartons, notes: notesText)
        
        controller.schedulePickup(input: pickupInput) { (error) in
            if let error = error {
                NSLog("\(error): Error scheduling pickup.")
            }
            DispatchQueue.main.async {
                print("Schedule made")
            }
        }
        
        
    }
}

//extension SchedulePickupViewController: DeselectTableViewCellOnDismissDelegate {
//    func deselectTableViewCell() {
//        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
//            // Clear selected cell when the user returns from selecting a property
//            self.tableView.deselectRow(at: selectionIndexPath, animated: false)
//        }
//    }
//}

// Custom cell delegate methods
//extension SchedulePickupViewController: AddCartonCellDelegate, UserAddedNotesDelegate, UserAddedPercentageDelegate, UserAddedPropertyDelegate, UserAddedDateAndTimeDelegate {
//    func userAddedDateAndTime(date: Date) {
//        pickupDate = date
//    }
//
//    func userAddedProperty(with property: Property) {
//        self.selectedProperty = property
//        self.tableView.beginUpdates()
//        self.tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
//        self.tableView.endUpdates()
//    }
    
    // PickupCartonTableViewCell
//    func userAddedPercentage(for cellIdentifier: UUID, cellType: CartonTypes, percentage: Int) {
//        switch cellType {
//        case .soap:
//            soapCartons[cellIdentifier] = percentage
//        case .paper:
//            paperCartons[cellIdentifier] = percentage
//        case .linens:
//            linenCartons[cellIdentifier] = percentage
//        case .bottles:
//            bottleCartons[cellIdentifier] = percentage
//        }
//    }
    
    // PickupNotesTableViewCell
//    func userAddedNotes(notes: String) {
//        self.notes = notes
//    }
//
//    // AddPickupCartonTableViewCell
//    func addCartonCell() {
//        let alert = UIAlertController(title: "Carton Type", message: nil, preferredStyle: .actionSheet)
//        let soapAction = UIAlertAction(title: "Soap", style: .default) { (UIAlertAction) in
//            self.cartons.append(0)
//            self.insertCartonCell()
//        }
//
//        let paperAction = UIAlertAction(title: "Paper", style: .default) { (UIAlertAction) in
//            self.cartons.append(1)
//            self.insertCartonCell()
//        }
//
//        let linensAction = UIAlertAction(title: "Linens", style: .default) { (UIAlertAction) in
//            self.cartons.append(2)
//            self.insertCartonCell()
//        }
//
//        let bottlesAction = UIAlertAction(title: "Bottles", style: .default) { (UIAlertAction) in
//            self.cartons.append(3)
//            self.insertCartonCell()
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//        alert.addAction(soapAction)
//        alert.addAction(paperAction)
//        alert.addAction(linensAction)
//        alert.addAction(bottlesAction)
//        alert.addAction(cancelAction)
//
//        present(alert, animated: true)
//    }
//
//    func insertCartonCell() {
//        self.tableView.beginUpdates()
//        self.tableView.insertRows(at: [IndexPath(row: 1, section: 1)], with: .left)
//        self.tableView.endUpdates()
//        self.tableView.reloadData()
//    }
//}
