//
//  UserController.swift
//  labs-ios-starter
//
//  Created by Christy Hicks on 10/12/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import OktaAuth

class UserController {
    
    static let shared = UserController()
    
    let oktaAuth = OktaAuth(baseURL: URL(string: "https://dev-668428.okta.com")!,
                            clientID: "0oapaqacafrGUTfKx4x6",
                            redirectURI: "labs://scaffolding/implicit/callback")
    
    private(set) var authenticatedUser: User?
    private let baseURL = URL(string: "http://35.208.9.187:9194/ios-api-1")!
    
    func getAuthenticatedUser(completion: @escaping () -> Void = { }) {
        var oktaCredentials: OktaCredentials
        
        do {
            oktaCredentials = try oktaAuth.credentialsIfAvailable()
        } catch {
            postAuthenticationExpiredNotification()
            NSLog("Credentials do not exist.  Unable to get authenticated user from Okta.")
            DispatchQueue.main.async {
                completion()
            }
            return
        }
        
        guard let userID = oktaCredentials.userID else {
            NSLog("Okta User ID is missing.")
            DispatchQueue.main.async {
                completion()
            }
            return
        }
        
        getUser(userID) { (user) in
            self.authenticatedUser = user
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func checkForExistingAuthenticatedUser(completion: @escaping (Bool) -> Void) {
        getAuthenticatedUser() {
            completion(self.authenticatedUser != nil)
        }
    }
    

    func getUser(_ userID: String, completion: @escaping (User?) -> Void) {
        var oktaCredentials: OktaCredentials
        
        do {
            oktaCredentials = try oktaAuth.credentialsIfAvailable()
        } catch {
            postAuthenticationExpiredNotification()
            NSLog("Credentials do not exist.  Unable to get user from Okta")
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        let input = LogInInput(token: oktaCredentials.idToken)
        BackendController.shared.logIn(input: input) { (error) in
            
        }
    }
    
    func postAuthenticationExpiredNotification() {
        NotificationCenter.default.post(name: .oktaAuthenticationExpired, object: nil)
    }
}
