//
//  PropertyDetailViewController.swift
//  labs-ios-starter
//
//  Created by Wyatt Harrell on 9/14/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

protocol StringTextField {
    var textFieldTextField: String? { get set }
}
class PropertyDetailViewController: UIViewController, StringTextField {
    var textFieldTextField: String?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var createButton: UIBarButtonItem!
    
    // MARK: - Properties
    var hideAll = false
    var addressInput = AddressInput()
    var delegate: PropertyInfoTableViewCell?
    var controller = BackendController.shared
    var lockTextField = false
    
    // MARK: - Properties
    private let accountInfoLabels = ["Name",
                                     "Property Type",
                                     "Number of Rooms",
                                     "Phone",
                                     "Billing Address",
                                     "Shipping Address",
                                     "Coordinates"]
    
    private var propertyData: [String] = []
    var property: Property? {
           didSet {
               updateViews()
           }
       }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setHideElements()
        setTextFieldsLocked()
        saveButton.isHidden = true
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    private func setHideElements() {
        if hideAll == true {
            stackView.isHidden = true
            self.editButton.isHidden = true
            self.deleteButton.isHidden = true
            self.saveButton.isHidden = true
            
        }
    }
    
    private func setTextFieldsLocked() {
        if lockTextField == true {
            delegate?.descriptionTextField.isUserInteractionEnabled = false
            delegate?.descriptionTextField.isEnabled = false
        }
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        
    }
    
    private func updateViews() {
        guard let property = property else { return }
    
        propertyData.append(property.name)
        propertyData.append(property.propertyType)
        propertyData.append("\(property.rooms)")
        propertyData.append(property.phone ?? "")
        propertyData.append(property.billingAddress?.address1 ?? "")
        propertyData.append(property.shippingAddress?.address1 ?? "")
        propertyData.append("\(property.coordinates?.longitude ?? 0), \(property.coordinates?.latitude ?? 0)")
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    @IBAction func editButtonIsTapped(_ sender: UIButton) {
        lockTextField = true
        UIView.animate(withDuration: 1.0) {
            sender.isHidden = true
            self.deleteButton.isHidden = true
            self.saveButton.isHidden = false
            
        }
    }
    @IBAction func createButtonTapped(_ sender: UIBarButtonItem) {
   
    }
    
    @IBAction func savedButtonTapped(_ sender: UIButton) {
        updatePropertyNow()
         navigationController?.popViewController(animated: true)
    }
    
    @objc func updatePropertyNow() {
        guard let property = property else { return }
        let input = UpdatePropertyInput(id: property.id, name: textFieldTextField, propertyType: .HOTEL, rooms: property.rooms, services: [.SOAP, .LINENS, .BOTTLES, .PAPER], collectionType: .GENERATED_LABEL, logo: property.logo, phone: property.phone, billingAddress: AddressInput(address1: property.billingAddress?.address1, address2: property.billingAddress?.address2, address3: property.billingAddress?.address3, city: property.billingAddress?.city, state: property.billingAddress?.state, postalCode: property.billingAddress?.postalCode, country: nil), shippingAddress: AddressInput(address1: property.shippingAddress?.address1, address2: property.shippingAddress?.address2, address3: property.shippingAddress?.address3, city: property.shippingAddress?.city, state: property.shippingAddress?.state, postalCode: property.shippingAddress?.postalCode, country: nil), coordinates: CoordinatesInput(longitude: property.coordinates?.longitude, latitude: property.coordinates?.latitude), shippingNote: property.shippingNote, notes: property.notes, hubId: property.hubId, impact: ImpactStatsInput(soapRecycled: property.impact?.soapRecycled, linensRecycled: property.impact?.linensRecycled, bottlesRecycled: property.impact?.bottlesRecycled, paperRecycled: property.impact?.paperRecycled, peopleServed: property.impact?.peopleServed, womenEmployed: property.impact?.womenEmployed), userIds: property.usersById, pickupIds: property.pickupsById, contractId: property.contractId)
        
        controller.updateProperty(input: input) { (error) in
            if let error = error {
                NSLog("Error in updating the property: \(error)")
                return
            } else {
                DispatchQueue.main.async {
                   
                    self.tableView.reloadData()
                   print("Property Updated")
                }
            }
        }
       
    }
    
    // MARK: - IBActions
    @IBAction func editButtonTapped(_ sender: Any) {
        view.addSubview(saveButton)
        saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        saveButton.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.saveButton.alpha = 1.0
        }
    }
}

extension PropertyDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountInfoLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyInfoCell", for: indexPath) as? PropertyInfoTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = accountInfoLabels[indexPath.row].uppercased()
        if propertyData.count > 0 {
            cell.descriptionTextField.text = propertyData[indexPath.row]
        } else {
            cell.descriptionTextField.text = ""
        }
        cell.detailVC = self
        
        return cell
    }
}
