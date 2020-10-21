//
//  UpdateUserProfileInput.swift
//  labs-ios-starter
//
//  Created by Karen Rodriguez on 8/26/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

class UpdateUserProfileInput: Input {

    private let id: String
    private let firstName, middleName, lastName, title, company, email, phone, skype: String?
    private let address: AddressInput?
    private let signupTime: Date?
    private let properties: [String]?

    private var propertiesQuery: String {
        guard let properties = properties else {
            return ""
        }
        
        var string = "properties: ["
        for id in properties {
            string += "\"\(id)\","
        }
        string += "]"
        return string
    }

    private var queryBody: String {
        var string = ""

        if let firstName = firstName {
            string += "firstName: \"\(firstName)\"\n"
        }
        if let middleName = middleName {
            string += "middleName: \"\(middleName)\"\n"
        }
        if let lastName = lastName {
            string += "lastName: \"\(lastName)\"\n"
        }
        if let title = title {
            string += "title: \"\(title)\"\n"
        }
        if let company = company {
            string += "company: \"\(company)\"\n"
        }
        if let email = email {
            string += "email: \"\(email)\"\n"
        }
        if let phone = phone {
            string += "phone: \"\(phone)\"\n"
        }
        if let skype = skype {
            string += "skype: \"\(skype)\"\n"
        }

        if let address = address {
            string += "\(address.formatted)\n"
        }

        if let signupTime = signupTime {
            string += "signupTime: \"\(signupTime.asShortDateString())\"\n"
        }

        if let _ = properties {
            string += propertiesQuery
        }
print(string)
        return string
    }

    var formatted: String {
        return """
        id: \"\(id)\"
        \(queryBody)
        """
    }

    internal init(id: String,
                  firstName: String? = nil,
                  middleName: String? = nil,
                  lastName: String? = nil,
                  title: String? = nil,
                  company: String? = nil,
                  email: String? = nil,
                  phone: String? = nil,
                  skype: String? = nil,
                  address: AddressInput? = nil,
                  signupTime: Date? = nil,
                  properties: [String]? = nil) {
        self.id = id
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.title = title
        self.company = company
        self.email = email
        self.phone = phone
        self.skype = skype
        self.address = address
        self.signupTime = signupTime
        self.properties = properties
    }


}
