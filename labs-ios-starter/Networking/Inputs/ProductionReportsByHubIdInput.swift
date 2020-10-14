//
//  ProductionReportsByHubIdInput.swift
//  labs-ios-starter
//
//  Created by Christy Hicks on 10/14/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

class ProductionReportsByHubIdInput: Input {
    let hubId: String
    
    var formatted: String {
        return """
            hubId: "\(hubId)"
            """
    }
    
    init (hubId: String) {
        self.hubId = hubId
    }
}
