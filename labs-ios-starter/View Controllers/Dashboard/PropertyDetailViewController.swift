//
//  PropertyDetailViewController.swift
//  labs-ios-starter
//
//  Created by Wyatt Harrell on 9/14/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class PropertyDetailViewController: UIViewController {

    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var property: Property? {
        didSet {
            updateViews()
        }
    }
    
    private var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: .colorESBGreen)
        button.setTitle("Save Changes", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    // MARK: - Properties
    private let accountInfoLabels = ["Name",
                                     "Property Type",
                                     "Number of Rooms",
                                     "Phone",
                                     "Billing Address",
                                     "Shipping Address",
                                     "Coordinates"]
    
    private var propertyData: [String] = []
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
        cell.descriptionTextField.text = propertyData[indexPath.row]
        
        return cell
    }
}
