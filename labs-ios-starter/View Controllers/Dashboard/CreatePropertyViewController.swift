//
//  CreatePropertyViewController.swift
//  labs-ios-starter
//
//  Created by Bharat Kumar on 10/19/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class CreatePropertyViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var propertyTypeTextField: UITextField!
    @IBOutlet weak var numberOfRoomsTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var billingAddressTextField: UITextField!
    @IBOutlet weak var shippingAddressTextField: UITextField!
    @IBOutlet weak var coordinatesTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    
    var property: Property?
    var input1: [CreatePropertyInput] = []
    var controller = BackendController.shared
     var newInput: CreatePropertyInput?
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.cornerRadius = 8
        //        fetchAll()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    @IBAction func createButtonTapped(_ sender: UIBarButtonItem) {
        //        guard let name = nameTextField.text,
        //            let propertyType = PropertyType(rawValue: propertyTypeTextField.text ?? ""),
        //            let rooms = numberOfRoomsTextField.text,
        //            let phone = phoneTextField.text,
        //            let billingAddress = billingAddressTextField.text,
        //            let shippingAddress = shippingAddressTextField.text,
        //            let coordinates = coordinatesTextField.text else { return }
        //        guard let property = property else { return }
        //        let input = CreatePropertyInput(name: name, propertyType: propertyType, rooms: Int(rooms) ?? 50 , services: [.BOTTLES, .LINENS, .PAPER, .OTHER], collectionType: .COURIER_CONSOLIDATED, logo: property.logo!, phone: phone, billingAddress: AddressInput(address1: billingAddress, address2: property.billingAddress?.address2, address3: property.billingAddress?.address3, city: property.billingAddress?.city, state: property.billingAddress?.state, postalCode: property.billingAddress?.postalCode, country: nil), shippingAddress: AddressInput(address1: shippingAddress, address2: property.shippingAddress?.address2, address3: property.shippingAddress?.address3, city: property.shippingAddress?.city, state: property.shippingAddress?.state, postalCode: property.shippingAddress?.postalCode, country: nil), coordinates: CoordinatesInput(longitude: Double(coordinates), latitude: Double(coordinates)), shippingNotes: property.shippingNote ?? "", notes: property.notes ?? "", hubId: property.hubId ?? "", userIds: property.usersById, contractId: property.contractId ?? "")
        //
        //               controller.createProperty(input: input) { error in
        //                   if let error = error {
        //                       NSLog("error in creating property: \(error)")
        //                       return
        //                   }
        //                   DispatchQueue.main.async {
        //                       print("property created")
        //                    self.navigationController?.popViewController(animated: true)
        //                   }
        //               }
    }
    
    
    
    @IBAction func createButtontap(_ sender: UIButton) {
        guard let name = nameTextField.text,
            let propertyType = propertyTypeTextField.text,
            !propertyType.isEmpty,
            let rooms = numberOfRoomsTextField.text,
            !rooms.isEmpty,
            let intRooms = Int(rooms),
            let phone = phoneTextField.text,
            !phone.isEmpty,
            let billingAddress = billingAddressTextField.text,
            !billingAddress.isEmpty,
            let shippingAddress = shippingAddressTextField.text,
            !shippingAddress.isEmpty,
            let coordinates = coordinatesTextField.text,
            !coordinates.isEmpty
            else { return }
        
        
        for property in controller.properties.values {
            let input = CreatePropertyInput(name: name, propertyType: PropertyType(rawValue: propertyType) ?? .HOTEL, rooms: intRooms , services: [.BOTTLES, .LINENS, .PAPER, .OTHER], collectionType: .COURIER_CONSOLIDATED, logo: URL(string: "www.hello.com"), phone: phone, billingAddress: AddressInput(address1: billingAddress, address2: property.billingAddress?.address2, address3: property.billingAddress?.address3, city: property.billingAddress?.city ?? "WHERE IN THE CITY", state: property.billingAddress?.state, postalCode: property.billingAddress?.postalCode, country: nil), shippingAddress: AddressInput(address1: shippingAddress, address2: property.shippingAddress?.address2, address3: property.shippingAddress?.address3, city: property.shippingAddress?.city ?? "WHERE IN THE CITY", state: property.shippingAddress?.state, postalCode: property.shippingAddress?.postalCode, country: nil), coordinates: CoordinatesInput(longitude: Double(-30.000), latitude: Double(30.000)), shippingNote: property.shippingNote ?? "", notes: property.notes ?? "", hubId: "HubId1", userIds: property.usersById, contractId: property.contractId ?? "")
            
            input1.append(input)
        }
        
       
        
        for input in input1 {
           newInput = input
        }
        guard let newInput = newInput else { return }
        
        if controller.loggedInUser.role == Role(rawValue: "HOTEL") {
                       controller.createProperty(input: newInput) { error in
                           if let error = error {
                               NSLog("error in creating property: \(error)")
                               return
                           }
                           DispatchQueue.main.async {
                               print("property created")
                               self.navigationController?.popViewController(animated: true)
                           }
                       }
                   }
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
