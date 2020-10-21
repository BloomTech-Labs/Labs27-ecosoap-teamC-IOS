//
//  CreatePropertyInput.swift
//  labs-ios-starter
//
//  Created by Bharat Kumar on 10/19/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

class CreatePropertyInput: Input {
    
    var name: String?
    var propertyType: String?
    var rooms: Int?
    var services: [HospitalityService]?
    var collectionType: CollectionType?
    var logo: URL?
    var phone: String?
    var billingAddress: AddressInput?
    var shippingAddress: AddressInput?
    var coordinates: CoordinatesInput
    var shippingNote: String?
    var notes: String?
    var hubId: String?
    var userIds: [String]?
    var contractId: String?
    
    private var servicesQuery: String {
        guard let services = services,
            !services.isEmpty else {
                return ""
        }
        
        var arr: [String] = []
        
        for service in services {
            arr.append(service.rawValue)
        }
        
        return "services: [\(arr.joined(separator: ", "))]\n"
    }
    
    private var userIdsQuery: String {
        guard let userIds = userIds,
            !userIds.isEmpty else {
                return ""
        }
        var string = "userIds: ["
        for id in userIds {
            string += "\"\(id)\", "
        }
        string += "]\n"
        return string
    }
    
    
    var formatted: String {
        var string = ""
        
        if let name = name {
            string += "name: \"\(name)\"\n"
        }
        
        if let propertyType = propertyType {
            string += "propertyType: \(propertyType)\n"
        }
        
        if let rooms = rooms {
            string += "rooms: \(rooms)\n"
        }
        
        string += servicesQuery
        
        if let collectionType = collectionType {
            string += "collectionType: \(collectionType)\n"
        }
        
        if let logo = logo {
            string += "logo: \"\(logo.absoluteString)\"\n"
        }
        
        if let phone = phone {
            string += "phone: \"\(phone)\"\n"
        }
        
        if let billingAddress = billingAddress {
            string += "billing\(billingAddress.formatted.firstLetterCapitalizing())\n"
        }
        
        if let shippingAddress = shippingAddress {
            string += "shipping\(shippingAddress.formatted.firstLetterCapitalizing())\n"
        }
     
            string += "\(coordinates.formatted)\n"
        
        
        if let shippingNote = shippingNote {
            string += "shippingNote: \"\(shippingNote)\"\n"
        }
        
        
        if let notes = notes {
            string += "notes: \"\(notes)\"\n"
        }
        
        if let hubId = hubId {
            string += "hubId: \"\(hubId)\"\n"
        }
      
        string += userIdsQuery
   
        
        if let contractId = contractId {
            string += "contractId: \"\(contractId)\"\n"
        }
        print(string)
        return string
    }
    
    
    
    init(name: String? = nil, propertyType: PropertyType? = nil, rooms: Int? = nil, services: [HospitalityService]? = nil, collectionType: CollectionType? = nil, logo: URL? = nil, phone: String? = nil, billingAddress: AddressInput? = nil, shippingAddress: AddressInput? = nil, coordinates: CoordinatesInput, shippingNote: String? = nil, notes: String? = nil, hubId: String? = nil, userIds: [String]? = nil, contractId: String? = nil) {
        
        self.name = name
        self.propertyType = propertyType?.rawValue
        self.rooms = rooms
        self.services = services
        self.collectionType = collectionType
        self.logo = logo
        self.phone = phone
        self.billingAddress = billingAddress
        self.shippingAddress = shippingAddress
        self.coordinates = coordinates
        self.shippingNote = shippingNote
        self.notes = notes
        self.hubId = hubId
        self.userIds = userIds
        self.contractId = contractId
    }
    
    
    
}
