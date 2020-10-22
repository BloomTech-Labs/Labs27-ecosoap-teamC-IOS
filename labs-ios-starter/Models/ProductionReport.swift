//
//  ProductionReport.swift
//  labs-ios-starter
//
//  Created by Christy Hicks on 10/7/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

struct ProductionReport: Hashable {
    // MARK: - Properties
    var id: String
    var date: Date
    var barsProduced, soapmakersWorked, soapmakerHours: Int?
    var soapPhotos, media: [String]?
    
    // MARK: - Initializers
    // Mock data initializer for testing.
    init() {
        self.id = "HubDailyProduction1"
        self.date = Date(shortDate: "09/01/2020") ?? Date()
        self.barsProduced = 5000
        self.soapmakersWorked = 6
        self.soapmakerHours = 8
        self.soapPhotos = ["http://www.fillmurray.com/1024/768"]
        self.media = ["http://www.fillmurray.com/1100/600", "http://www.fillmurray.com/800/800"]
    }
    
    // GraphQL initializer
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let dateString = dictionary["date"] as? String else {
            NSLog("Error unwrapping non-optional properties for Production Report:")
            NSLog("\tID: \(String(describing: dictionary["id"])) ")
            NSLog("\tDate: \(String(describing: dictionary["date"]))")
            return nil
        }
        
        self.id = id
        self.date = Date()
        
        self.date = Date(shortDate: dateString) ?? Date()
        
        if let barsProduced = dictionary["barsProduced"] as? Int {
            self.barsProduced = barsProduced
        }
        
        if let soapmakersWorked = dictionary["soapmakersWorked"] as? Int {
            self.soapmakersWorked = soapmakersWorked
        }
        
        if let soapmakerHours = dictionary["soapmakerHours"] as? Int {
            self.soapmakerHours = soapmakerHours
        }
        
        if let soapPhotos = dictionary["soapPhotos"] as? [String] {
            self.soapPhotos = soapPhotos
        }
        
        if let media = dictionary["media"] as? [String] {
            self.media = media
        }
    }
}


