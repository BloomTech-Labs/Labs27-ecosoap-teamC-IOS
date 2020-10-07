//
//  ProductionReport.swift
//  labs-ios-starter
//
//  Created by Christy Hicks on 10/7/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

class ProductionReport {
    let id, hubID: String
    var date: Date
    var barsProduced, soapmakersWorked, soapmakerHours: Int?
    var soapPhotoURLs, mediaURLs: [URL]?


    init() {
        self.id = "HubDailyProduction1"
        self.hubID = "HubId1"
        self.date = Date(shortDate: "09/01/2020") ?? Date()
        self.barsProduced = 5000
        self.soapmakersWorked = 6
        self.soapmakerHours = 8
        
        let soapPhotoStringsArray = ["http://www.fillmurray.com/1024/768"]
        
        self.soapPhotoURLs = convertStringArrayToURLs(stringArray: soapPhotoStringsArray)
        
        let mediaStringsArray = ["http://www.fillmurray.com/1100/600", "http://www.fillmurray.com/800/800"]
        
        self.mediaURLs = convertStringArrayToURLs(stringArray: mediaStringsArray)
    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String else {
            NSLog("Error fetching Production Report for ID: \(String(describing: dictionary["id"]))")
                return nil
        }
        
        self.id = id
        
        if let hubContainer = dictionary["hub"] as? [String: Any] {
            if let hubID = hubContainer["id"] as? String {
                self.hubID = hubID
            } else {
                self.hubID = "HubId1"
            }
        } else {
            self.hubID = "HubId1"
        }
        
        if let dateString = dictionary["date"] as? String {
            self.date = Date(longDate: dateString)!
        } else {
            self.date = Date()
        }
        
        if let barsProduced = dictionary["barsProduced"] as? Int {
            self.barsProduced = barsProduced
        }
        
        if let soapmakersWorked = dictionary["soapmakersWorked"] as? Int {
            self.soapmakersWorked = soapmakersWorked
        }
        
        if let soapmakerHours = dictionary["soapmakerHours"] as? Int {
            self.soapmakerHours = soapmakerHours
        }
        
        if let soapPhotoStringsArray = dictionary["soapPhotos"] as? [String] {
            self.soapPhotoURLs = convertStringArrayToURLs(stringArray: soapPhotoStringsArray)
        }
        
        if let mediaStringsArray = dictionary["media"] as? [String] {
            self.soapPhotoURLs = convertStringArrayToURLs(stringArray: mediaStringsArray)
        }
    }
    
    func convertStringArrayToURLs(stringArray: [String]) -> [URL] {
        var urlArray = [URL]()
        for url in stringArray {
            if let newURL = URL(string: url) {
                urlArray.append(newURL)
            }
        }
        return urlArray
    }
}


