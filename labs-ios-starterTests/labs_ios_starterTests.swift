//
//  labs_ios_starterTests.swift
//  labs-ios-starterTests
//
//  Created by Bharat Kumar on 10/16/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import XCTest
@testable import labs_ios_starter
import OktaAuth

class labs_ios_starterTests: XCTestCase {

    let token: String = "eyJraWQiOiJRZURVMExTNEgzNXlqNVNBVU1uZkI3ZFNVWFdWWThMS0d2Tnh0QnVkUVRvIiwiYWxnIjoiUlMyNTYifQ.eyJ2ZXIiOjEsImp0aSI6IkFULnFTVXJWcUtvOVBPakNVRVNyWFN0OFZiQS1XQW5oR251amNOWXhqMlpBUTQiLCJpc3MiOiJodHRwczovL2Rldi02Njg0Mjgub2t0YS5jb20vb2F1dGgyL2RlZmF1bHQiLCJhdWQiOiJhcGk6Ly9kZWZhdWx0IiwiaWF0IjoxNjAyODc2NDY4LCJleHAiOjE2MDI4ODAwNjgsImNpZCI6IjBvYXBhcWFjYWZyR1VUZkt4NHg2IiwidWlkIjoiMDB1MTNhbTVrMlZ5b1I3Sms0eDciLCJzY3AiOlsib3BlbmlkIl0sInN1YiI6ImxsYW1hMDAxQG1haWxkcm9wLmNjIn0.FG5qZGrDHQxtBtsY4iOO4s4aZR4XaaT4X9JtfFPT9yW0oxy4j7GCB6jJkkbfReL120NIzN5eOI7T5JPqZj_oBemimuxzmPX3CFNwZCwyF3HWki74H1Ap_EP335P1_hmDG7P53JW6f1xBVGmHOBS8b2RUxnCRZx3YLMS4LWE-hlglWwssUmD02awZhfEBAS1X20PiXsaTTWMTkifTjOkbvJTuC-pNX8E5uwU0NPpIlv6s4L1lyRAO-j-xmP896FtXhRfGAdY3H9ctMaOKGPFKfhul3Ve9ue2BiXWvMHkDwE8GbZvCnd9tnfKIoXJF96uSqBDGWh3i0-IG0aalK2takg"
    
    var controller: BackendController!
    var timeout: Double = 10
    var property: Property?
     
    
    override func setUpWithError() throws {
        controller = BackendController.shared
    }

    override func tearDownWithError() throws {
        
    }
    
    func testUpdateProperty() {
        guard let property = property else { return }
        
     let input1 = UpdatePropertyInput(id: property.id, name: "Kumar Hotel", propertyType: .HOTEL, rooms: property.rooms, services: [.SOAP, .LINENS, .BOTTLES, .PAPER], collectionType: .GENERATED_LABEL, logo: property.logo, phone: property.phone, billingAddress: AddressInput(address1: property.billingAddress?.address1, address2: property.billingAddress?.address2, address3: property.billingAddress?.address3, city: property.billingAddress?.city, state: property.billingAddress?.state, postalCode: property.billingAddress?.postalCode, country: nil), shippingAddress: AddressInput(address1: property.shippingAddress?.address1, address2: property.shippingAddress?.address2, address3: property.shippingAddress?.address3, city: property.shippingAddress?.city, state: property.shippingAddress?.state, postalCode: property.shippingAddress?.postalCode, country: nil), coordinates: CoordinatesInput(longitude: property.coordinates?.longitude, latitude: property.coordinates?.latitude), shippingNote: property.shippingNote, notes: property.notes, hubId: property.hubId, impact: ImpactStatsInput(soapRecycled: property.impact?.soapRecycled, linensRecycled: property.impact?.linensRecycled, bottlesRecycled: property.impact?.bottlesRecycled, paperRecycled: property.impact?.paperRecycled, peopleServed: property.impact?.peopleServed, womenEmployed: property.impact?.womenEmployed), userIds: property.usersById, pickupIds: property.pickupsById, contractId: property.contractId)
        var oktaCredentials: OktaCredentials
        let expectedUpdateProperty = expectation(description: "Testing update property.")
       let input = LogInInput(token: token)
        controller.logIn(input: input) { _ in
            expectedUpdateProperty.fulfill()
        }
        wait(for: [expectedUpdateProperty], timeout: timeout)
        
        let updateExpect = expectation(description: "Expectation for updating property")
        controller.updateProperty(input: input1) { _ in
            updateExpect.fulfill()
            
        }
        
        wait(for: [updateExpect], timeout: timeout)
    }
}
