//
//  Property.swift
//  labs-ios-starter
//
//  Created by Karen Rodriguez on 8/13/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

class Property {

    let id, name, propertyType, collectionType: String
    let rooms: Int
    var phone, shippingNote, notes, contractId: String?
    var services: [String] = []
    var logo: URL?
    var billingAddress, shippingAddress: Address?
    var coordinates: Coordinates?
    var hub: Hub?
    var impact: ImpactStats?
    var usersById: [String] = []
    var pickupsById: [String] = []
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
        let name = dictionary["name"] as? String,
        let propertyType = dictionary["propertyType"] as? String,
        let collectionType = dictionary["collectionType"] as? String,
        let rooms = dictionary["rooms"] as? Int,
        let services = dictionary["services"] as? [String] else {
            NSLog("Error unwrapping non-optional Property properties:")
            NSLog("\tID: \(String(describing: dictionary["id"]))")
            NSLog("\tName: \(String(describing: dictionary["name"]))")
            NSLog("\tProperty Type: \(String(describing: dictionary["propertyType"]))")
            NSLog("\tCollection Type: \(String(describing: dictionary["collectionType"]))")
            NSLog("\tRooms: \(String(describing: dictionary["rooms"]))")
            NSLog("\tServices: \(String(describing: dictionary["services"]))")
            return nil
        }

        self.id = id
        self.name = name
        self.propertyType = propertyType
        self.collectionType = collectionType
        self.rooms = rooms
        self.services = services

        self.phone = dictionary["phone"] as? String
        self.shippingNote = dictionary["shippingNote"] as? String
        self.notes = dictionary["notes"] as? String
        self.logo = dictionary["logo"] as? URL


        if let billingContainer = dictionary["billingAddress"] as? [String: Any] {
            self.billingAddress = Address(dictionary: billingContainer)
        }

        if let shippingContainer = dictionary["shippingAddress"] as? [String: Any] {
            self.shippingAddress = Address(dictionary: shippingContainer)
        }

        if let coordinatesContainer = dictionary["coordinates"] as? [String: Any] {
            self.coordinates = Coordinates(dictionary: coordinatesContainer)
        }

        if let hubContainer = dictionary["hub"] as? [String: Any] {
            self.hub = Hub(dictionary: hubContainer)
        }

        if let impactContainer = dictionary["impact"] as? [String: Any] {
            self.impact = ImpactStats(dictionary: impactContainer)
        }

        if let users = dictionary["users"] as? [[String: Any]] {
            for user in users {
                if let id = user["id"] as? String {
                    self.usersById.append(id)
                }
            }
        }

        if let pickups = dictionary["pickups"] as? [[String: Any]] {
            for pickup in pickups {
                if let id = pickup["id"] as? String {
                    self.pickupsById.append(id)
                }
            }
        }

        if let contract = dictionary["contract"] as? [String: Any] {
            self.contractId = contract["id"] as? String
        }

    }

}



