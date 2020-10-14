//
//  DeleteProductionReportInput.swift
//  labs-ios-starter
//
//  Created by Christy Hicks on 10/14/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

class DeleteProductionReportInput: Input {
    private let id: String
    
    var formatted: String {
        let string = """
        id: \"\(id)\"
        """
        return string
    }
    
    init(id: String) {
        self.id = id
    }
}
