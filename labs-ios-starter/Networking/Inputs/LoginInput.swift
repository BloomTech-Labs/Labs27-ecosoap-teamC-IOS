//
//  LogInInput.swift
//  labs-ios-starter
//
//  Created by Christy Hicks on 10/12/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

class LogInInput: Input {
    let token: String
    
    var formatted: String {
        return """
            token: \(token)
            """
    }
    
    init (token: String) {
        self.token = token
    }
    
}
