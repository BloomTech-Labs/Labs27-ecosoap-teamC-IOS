//
//  MockHotel.swift
//  labs-ios-starter
//
//  Created by Bharat Kumar on 10/7/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

struct MockHotelNames {
    var type: String
    var names: [String]!
    var isExpanded: Bool
   
    init(type: String, names: [String], isExpanded: Bool) {
        self.type = type
        self.names = names
        self.isExpanded = isExpanded
    }
    
}


