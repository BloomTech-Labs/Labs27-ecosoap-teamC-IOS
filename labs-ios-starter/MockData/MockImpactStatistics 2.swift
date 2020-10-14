//
//  MockImpactStatistics.swift
//  labs-ios-starter
//
//  Created by Bharat Kumar on 10/12/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation


class MockImpactStats {

    let soapRecycled, linensRecycled, bottlesRecycled, paperRecycled, peopleServed, womenEmployed: Int?
    
    init() {
        self.soapRecycled = 200
        self.linensRecycled = 500
        self.bottlesRecycled = 300
        self.paperRecycled = 400
        self.peopleServed = 600
        self.womenEmployed = 700
    }

    init?(dictionary: [String: Any]) {
        self.soapRecycled = dictionary["soapRecycled"] as? Int
        self.linensRecycled = dictionary["linensRecycled"] as? Int
        self.bottlesRecycled = dictionary["bottlesRecycled"] as? Int
        self.paperRecycled = dictionary["paperRecycled"] as? Int
        self.peopleServed = dictionary["peopleServed"] as? Int
        self.womenEmployed = dictionary["womenEmployed"] as? Int
    }

}
