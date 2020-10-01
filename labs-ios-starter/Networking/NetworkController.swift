//
//  NetworkController.swift
//  labs-ios-starter
//
//  Created by Karen Rodriguez on 8/12/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

func newError(message string: String) -> NSError {
    return NSError(domain: string, code: 0, userInfo: nil)
}

class BackendController {

    enum Errors: Error {
        case ObjectInitFail
        case RequestInitFail
        case NoDataInResponse
    }

    private let apiURL: URL = URL(string: "http://35.208.9.187:9096/ios-api-3")!

    var loggedInUser: User = User()

    static let shared: BackendController = BackendController()

    private init() {
    }

    var users: [String: User] = [:]
    var properties: [String: Property] = [:]
    var pickups: [String: Pickup] = [:]
    var hubs: [String: Hub] = [:]
    var pickupCartons: [String: PickupCarton] = [:]
    var hospitalityContracts: [String: HospitalityContract] = [:]

    private var parsers: [ResponseModel: (Any?) throws ->()] = [.property: BackendController.propertyParser,
                                                        .properties: BackendController.propertiesParser,
                                                        .user: BackendController.userParser,
                                                        .pickup:  BackendController.pickupParser,
                                                        .pickups: BackendController.pickupsParser,
                                                        .hub: BackendController.hubParser,
                                                        ]

    private static func propertyParser(data: Any?) throws {
        guard let propertyContainer = data as? [String: Any] else {
            throw newError(message: "Couldn't cast data as PROPERTY dictionary for initialization")
        }

        guard let property = Property(dictionary: propertyContainer) else {
            throw Errors.ObjectInitFail
        }
        shared.properties[property.id] = property
    }

    private static func propertiesParser(data: Any?) throws {
        guard let propertiesContainer = data as? [[String: Any]] else {
            throw newError(message: "Couldn't PROPERTIES cast data as dictionary for initialization")
        }

        for prop in propertiesContainer {
            try? propertyParser(data:prop)
        }
    }

    private static func userParser(data: Any?) throws {
        guard let userContainer = data as? [String: Any] else {
            throw newError(message: "Couldn't USER cast data as dictionary for initialization")
        }

        guard let user = User(dictionary: userContainer) else {
            throw Errors.ObjectInitFail
        }
        shared.users[user.id] = user
    }

    private static func pickupParser(data: Any?) throws {
        guard let pickupContainer = data as? [String: Any] else {
            throw newError(message: "Couldn't PICKUP cast data as dictionary for initialization")
        }

        guard let pickup = Pickup(dictionary: pickupContainer) else {
            throw Errors.ObjectInitFail
        }

        if let cartonContainer = pickupContainer["cartons"] as? [[String: Any]] {
            try cartonParser(data: cartonContainer)
        }
        shared.pickups[pickup.id] = pickup
    }

    private static func pickupsParser(data: Any?) throws {
        guard let pickupsContainer = data as? [[String: Any]] else {
            throw newError(message: "Couldn't cast data as dictionary for PICKUPS container.")
        }

        for pickup in pickupsContainer {
            try pickupParser(data: pickup)
        }
    }

    private static func hubParser(data: Any?) throws {
        guard let hubContainer = data as? [String: Any] else {
            throw newError(message: "Couldn't cast data as dictionary for HUB initialization.")
        }

        guard let hub = Hub(dictionary: hubContainer) else {
            throw Errors.ObjectInitFail
        }
        shared.hubs[hub.id] = hub
    }

    private static func cartonParser(data: Any?) throws {
        guard let cartonsContainer = data as? [[String: Any]] else {
            throw newError(message: "Couldn't cast data as dictionary for Cartons container.")
        }

        for cartonDict in cartonsContainer {
            if let carton = PickupCarton(dictionary: cartonDict) {
                shared.pickupCartons[carton.id] = carton
            }
        }

    }

    // MARK: - Queries

    func propertiesByUserId(id: String, completion: @escaping (Error?) -> Void) {
        guard let request = Queries(name: .propertiesByUserId, id: id) else {
            completion(Errors.RequestInitFail)
            return
        }
        requestAPI(with: request) { (_, error) in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }

    func propertyById(id: String, completion: @escaping (Error?) -> Void) {
        guard let request = Queries(name: .propertyById, id: id) else {
            completion(Errors.RequestInitFail)
            return
        }
        requestAPI(with: request) { (_, error) in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }

    func userById(id: String, completion: @escaping (Error?) -> Void) {
        guard let request = Queries(name: .userById, id: id) else {
            completion(Errors.RequestInitFail)
            return
        }
        requestAPI(with: request) { (_, error) in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }

    func hubByPropertyId(propertyId: String, completion: @escaping (Error?) -> Void) {
        guard let request = Queries(name: .hubByPropertyId, id: propertyId) else {
            completion(Errors.RequestInitFail)
            return
        }
        requestAPI(with: request) { (_, error) in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }

    func pickupsByPropertyId(propertyId: String, completion: @escaping (Error?) -> Void) {
        guard let request = Queries(name: .pickupsByPropertyId, id: propertyId) else {
            completion(Errors.RequestInitFail)
            return
        }
        requestAPI(with: request) { (_, error) in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }

    func impactStatsByPropertyId(id: String, completion: @escaping (Error?) -> Void) {
        guard let request = Queries(name: .impactStatsByPropertyId, id: id) else {
            completion(Errors.RequestInitFail)
            return
        }

        requestAPI(with: request) { (data, error) in
            if let error = error {
                completion(error)
                return
            }

            guard let property = self.properties[id] else {
                NSLog("This property is not currently stored into memory. Can't store impact stats.")
                completion(NSError(domain: "Error locating property.", code: 0, userInfo: nil))
                return
            }

            guard let container = data as? [String: Any] else {
                NSLog("Couldn't unwrap data as dictionary for initializing an ImpactStats object.")
                completion(NSError(domain: "Error unwrapping data.", code: 0, userInfo: nil))
                return
            }

            guard let stats = ImpactStats(dictionary: container) else {
                completion(NSError(domain: "Error initializing ImpactStats", code: 0, userInfo: nil))
                return
            }

            property.impact = stats
            completion(nil)
        }
    }

    func initialFetch(userId: String, completion: @escaping (Error?) -> Void) {
        guard let request = Queries(name: .monsterFetch, id: userId) else {
            completion(Errors.RequestInitFail)
            return
        }

        requestAPI(with: request) { (data, error) in
            if let error = error {
                completion(error)
                return
            }

            // Cast the data as a dictionary.
            guard let container = data as? [String: Any] else {
                NSLog("Couldn't unwrap USER data as dictionary in initial fetch.")
                NSLog("\(String(describing: data))")
                completion(NSError(domain: "Error unwrapping data.", code: 0, userInfo: nil))
                return
            }

            // Start by initializing the user.
            guard let user = User(dictionary: container) else {
                NSLog("Failed to initialize new user in initial fetch.")
                completion(NSError(domain: "Error unwrapping data.", code: 0, userInfo: nil))
                return
            }
            self.users[user.id] = user

            // Unwrap array of Properties if present
            guard let properties = container["properties"] as? [[String: Any]] else {
                NSLog("Failed to unwrap properties array from user payload.")
                NSLog("\tProperties: \(String(describing: container["properties"]))")
                completion(NSError(domain: "Error unwrapping data.", code: 0, userInfo: nil))
                return
            }

            // Initialize every property and add it to the dictionary
            for propertyContainer in properties {
                // Initializer handles error logs if failed to initialize.
                if let property = Property(dictionary: propertyContainer) {
                    self.properties[property.id] = property

                    // For every properly initialized property.
                    // If they contain a valid Hub, add it to the dictionary.
                    if let hub = property.hub {
                        self.hubs[hub.id] = hub
                    }

                    // Handle pickups.
                    if let pickups = propertyContainer["pickups"] as? [[String: Any]] {
                        for pickupContainer in pickups {
                            // Initializer handles error logs if failed to initialize.
                            if let pickup = Pickup(dictionary: pickupContainer) {
                                self.pickups[pickup.id] = pickup

                                // Handle Cartons
                                if let cartons = pickupContainer["cartons"] as? [[String: Any]] {
                                    for cartonContainer in cartons {
                                        // Initializer handles error logs if failed to initialize.
                                        if let carton = PickupCarton(dictionary: cartonContainer) {
                                            self.pickupCartons[carton.id] = carton
                                        }
                                    }
                                } else {
                                    NSLog("Couldn't cast array of dictionary for pickup cartons data for pickup with ID: \(pickup.id)")
                                }
                            }
                        }
                    } else {
                        NSLog("Couldn't cast array of dictionary for pickup data for property with ID: \(property.id)")
                    }

                    // Handle contract.
                    if let contractContainer = propertyContainer["contract"] as? [String: Any] {
                        // Initializer handles error logs if failed to initialize.
                        if let contract = HospitalityContract(dictionary: contractContainer) {
                            self.hospitalityContracts[contract.id] = contract

                        }
                    } else {
                        NSLog("Couldn't cast contract dictionary for property with ID: \(property.id)")
                    }
                }
            }

            completion(nil)
        }
    }

    // MARK: Mutations

    func schedulePickup(input: PickupInput, completion: @escaping (Error?) -> Void) {
        guard let request = Mutator(name: .schedulePickup, input: input) else {
            completion(Errors.RequestInitFail)
            return
        }
        requestAPI(with: request) { (_, error) in
            if let error = error {
                completion(error)
                return
            }

            completion(nil)
        }
    }

    func cancelPickup(input: CancelPickupInput, completion: @escaping (Error?) -> Void) {
        guard let request = Mutator(name: .cancelPickup, input: input) else {
            completion(Errors.RequestInitFail)
            return
        }
        requestAPI(with: request) { (_, error) in
            if let error = error {
                completion(error)
                return
            }

            completion(nil)
        }
    }

    func updateUserProfile(input: UpdateUserProfileInput, completion: @escaping (Error?) -> Void) {
        guard let request = Mutator(name: .updateUserProfile, input: input) else {
            completion(Errors.RequestInitFail)
            return
        }
        requestAPI(with: request) { (_, error) in
            if let error = error {
                completion(error)
                return
            }

            completion(nil)
        }
    }

    func updateProperty(input: UpdatePropertyInput, completion: @escaping (Error?) -> Void) {
        guard let request = Mutator(name: .updateProperty, input: input) else {
            completion(Errors.RequestInitFail)
            return
        }
        requestAPI(with: request) { (_, error) in
            if let error = error {
                completion(error)
                return
            }

            completion(nil)
        }
    }

    private func requestAPI(with request: Request, completion: @escaping (Any?, Error?) -> Void) {
        var urlRequest = URLRequest(url: apiURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: ["query": request.body], options: [])

        print("Request body")
        print(String(data: urlRequest.httpBody!, encoding: .utf8)!)
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let _ = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, Errors.NoDataInResponse)
                return
            }

            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let dataContainer = dict?["data"]  as? [String: Any] else {
                    NSLog("No data in request response.")
                    completion(nil, Errors.NoDataInResponse)
                    return
                }

                var queryContainer:[String: Any]?

                let payloadString = request.payload.rawValue

                if request.name == "monsterFetch" {
                    guard let queryContainer = dataContainer["userById"] as? [String: Any] else {
                        completion(nil, NSError(domain: "Query container is nil.", code: 0, userInfo: nil))
                        return
                    }
                    completion(queryContainer[payloadString], nil)
                    return
                } else {
                    queryContainer = dataContainer[request.name] as? [String: Any]
                }


                guard let parser = self.parsers[request.payload] else {
                    print("The payload \(payloadString) doesn't possess a parser.")
                    completion(queryContainer?[payloadString], nil)
                    return
                }
                
                try parser(queryContainer?[payloadString])

                completion(nil, nil)

            } catch let error {
                completion(nil, error)
            }
        }.resume()
    }
}
