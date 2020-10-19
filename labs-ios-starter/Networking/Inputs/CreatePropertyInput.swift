//
//  CreatePropertyInput.swift
//  labs-ios-starter
//
//  Created by Bharat Kumar on 10/19/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

class CreatePropertyInput: Input {
    
    var name: String
    var propertyType: String
    var rooms: Int
    var services: [HospitalityService]
    var collectionType: CollectionType
    var logo: URL?
    var phone: String?
    var billingAddress: AddressInput
    var shippingAddress: AddressInput
    var coordinates: CoordinatesInput?
    var shippingNote: String?
    var notes: String?
    var hubId: String
    var userIds: [String]
    var contractId: String
    
    var formatted: String {
        let string = """
        name: \(name)
        propertyType: \(propertyType)
        rooms: \(rooms)
        services: \(services)
        collectionType: \(collectionType)
        logo: \(String(describing: logo))
        phone: \(String(describing: phone))
        billingAddress: \(billingAddress)
        shippingAddress: \(shippingAddress)
        coordinates: \(String(describing: coordinates))
        shippingNote: \(String(describing: shippingNote))
        notes: \(String(describing: notes))
        hubId: \(hubId)
        userIds: \(userIds)
        contractId: \(contractId)
        """
        return string
    }
    
    init(name: String, propertyType: String, rooms: Int, services: [HospitalityService], collectionType: CollectionType, logo: URL, phone: String, billingAddress: AddressInput, shippingAddress: AddressInput, coordinates: CoordinatesInput, shippingNotes: String, notes: String, hubId: String, userIds: [String], contractId: String) {
        
        self.name = name
        self.propertyType = propertyType
        self.rooms = rooms
        self.services = services
        self.collectionType = collectionType
        self.logo = logo
        self.phone = phone
        self.billingAddress = billingAddress
        self.shippingAddress = shippingAddress
        self.notes = notes
        self.hubId = hubId
        self.userIds = userIds
        self.contractId = contractId
    }
    
    
    
}
