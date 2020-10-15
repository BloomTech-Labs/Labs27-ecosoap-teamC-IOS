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
    case productionReports
    case productionReport
    case success
}

enum MutationName: String {
    case logIn
    case schedulePickup
    case cancelPickup
    case updateUserProfile
    case updateProperty
    case createProductionReport
    case updateProductionReport
    case deleteProductionReport
}

enum QueryName: String {
    case userById
    case propertiesByUserId
    case propertyById
    case impactStatsByPropertyId
    case hubByPropertyId
    case pickupsByPropertyId
    case productionReportsByHubId
    case monsterFetch
}
