//
//  ControllerEnums.swift
//  labs-ios-starter
//
//  Created by Karen Rodriguez on 8/26/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

enum ResponseModel: String {
    case user
    case logIn
    case property
    case properties
    case impactStats
    case hub
    case pickups
    case pickup
    case payment
    case payments
}

enum MutationName: String {
    case logIn
    case schedulePickup
    case cancelPickup
    case createPayment
    case updateUserProfile
    case updateProperty
}

enum QueryName: String {
    case userById
    case propertiesByUserId
    case propertyById
    case impactStatsByPropertyId
    case hubByPropertyId
    case pickupsByPropertyId
    case nextPaymentByPropertyId
    case paymentsByPropertyId
    case monsterFetch
}
