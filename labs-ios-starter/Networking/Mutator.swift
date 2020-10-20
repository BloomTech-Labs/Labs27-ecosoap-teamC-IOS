//
//  Mutator.swift
//  labs-ios-starter
//
//  Created by Karen Rodriguez on 8/25/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

class Mutator: Request {

    var body: String

    var payload: ResponseModel

    var name: String

    private static let collection = [MutationName.logIn: Mutator.logInInput,
                                     .schedulePickup: Mutator.schedulePickup,
                                     .cancelPickup: Mutator.cancelPickup,
                                     .updateUserProfile: Mutator.updateUserProfile,
                                     .updateProperty: Mutator.updateProperty,
                                     .createProductionReport: Mutator.createProductionReport,
                                     .updateProductionReport: Mutator.updateProductionReport,
                                     .deleteProductionReport: Mutator.deleteProductionReport]

    private static let payloads: [MutationName: ResponseModel] = [.logIn: .user,
                                                                  .schedulePickup: .pickup,
                                                                  .cancelPickup: .pickup,
                                                                  .updateUserProfile: .user,
                                                                  .updateProperty: .property,
                                                                  .createProductionReport: .productionReport,
                                                                  .updateProductionReport: .productionReport,
                                                                  .deleteProductionReport: .success]

    init?(name: MutationName, input: Input) {
        guard let function = Mutator.collection[name] else {
            NSLog("Couldn't find this mutation in the collection. Check your implementation.")
            return nil
        }

        guard let body = function(input) else {
            return nil
        }

        guard let payload = Mutator.payloads[name] else {
            NSLog("Couldn't find a matching payload name. Check your implementation.")
            return nil
        }
        self.body = body
        self.payload = payload
        self.name = name.rawValue
    }

    private static func logInInput(input: Input) -> String? {
        guard let token = input as? LogInInput else {
            NSLog("Couldn't cast input to LogInInput.  Please make sure your input matches the mutation's required input.")
            return nil
        }
        return """
        mutation {
            logIn(input:{
                \(token.formatted)
            }) {
                user {
                    id
                    firstName
                    middleName
                    lastName
                    title
                    company
                    email
                    password
                    phone
                    skype
                    address {
                        address1
                        address2
                        address3
                        city
                        state
                        postalCode
                        country
                        formattedAddress
                    }
                    signupTime
                    role
                    properties {
                        id
                    }
                    hub {
                        id
                        name
                        address {
                            address1
                            address2
                            address3
                            city
                            state
                            postalCode
                            country
                            formattedAddress
                        }
                        email
                        phone
                        properties {
                            id
                        }
                        workflow
                    }
                }
            }
        }
"""
    }
    
    private static func schedulePickup(input: Input) -> String? {
        guard let pickup = input as? PickupInput else {
            NSLog("Couldn't cast input to PickupInput. Please make sure your input matches the mutation's required input.")
            return nil
        }
        return """
        mutation {
          schedulePickup(input:{
            \(pickup.formatted)
          }) {
            pickup {
              id
              confirmationCode
              collectionType
              status
              readyDate
              pickupDate
              property {
                id
              }
              cartons {
                id
                product
                percentFull
              }
              notes
            }
            label
          }
        }
        """
    }

    private static func cancelPickup(input: Input) -> String? {
        guard let pickup = input as? CancelPickupInput else {
            NSLog("Couldn't cast input to CancelPickupInput. Please make sure your input matches the mutation's required input.")
            return nil
        }
        return """
        mutation {
          cancelPickup(input: {
            \(pickup.formatted)
          }) {
            pickup {
              id
              confirmationCode
              collectionType
              status
              readyDate
              pickupDate
              property {
                id
              }
              cartons {
                id
                product
                percentFull
              }
              notes
            }
          }
        }

        """
    }

    private static func updateUserProfile(input: Input) -> String? {
        guard let user = input as? UpdateUserProfileInput else {
            NSLog("Couldn't cast input to UpdateUserProfileInput. Please make sure your input matches the mutation's required input.")
            return nil
        }

        return """
        mutation {
          updateUserProfile(input: {
            \(user.formatted)
          }) {
            user {
              id
              firstName
              middleName
              lastName
              title
              company
              email
              password
              phone
              skype
              address {
                address1
                address2
                address3
                city
                state
                postalCode
                country
                # formattedAddress
              }
              signupTime
              properties {
                id
              }
            }
          }
        }

        """
    }

    private static func updateProperty(input: Input) -> String? {
        guard let property = input as? UpdatePropertyInput else {
            NSLog("Couldn't cast input to UpdateUserProfileInput. Please make sure your input matches the mutation's required input.")
            return nil
        }

        return """
        mutation {
          updateProperty(input: {
            \(property.formatted)
          }) {
            property {
                id
                name
                propertyType
                rooms
                services
                collectionType
                logo
                phone
                billingAddress {
                  address1
                  address2
                  address3
                  city
                  state
                  postalCode
                  country
                  # formattedAddress
                }
                shippingAddress {
                  address1
                  address2
                  address3
                  city
                  state
                  postalCode
                  country
                  # formattedAddress
                }
                coordinates {
                  longitude
                        latitude

                }
                shippingNote
                notes
                hub {
                  id
                  name
                  address {
                    address1
                    address2
                    address3
                    city
                    state
                    postalCode
                    country
                    # formattedAddress
                  }
                  email
                  phone
                  coordinates {
                    longitude
                            latitude
                  }
                  properties {
                    id
                  }
                  workflow
                  impact {
                    soapRecycled
                    linensRecycled
                    bottlesRecycled
                    paperRecycled
                    peopleServed
                    womenEmployed
                  }
                }
                impact {
                  soapRecycled
                  linensRecycled
                  bottlesRecycled
                  paperRecycled
                  peopleServed
                  womenEmployed
                }
                users {
                  id
                }
                pickups {
                  id
                  confirmationCode
                  collectionType
                  status
                  readyDate
                  pickupDate
                  property {
                    id
                  }
                  cartons {
                    id
                    product
                    percentFull
                  }
                  notes
                }
                contract {
                  id
                  startDate
                  endDate
                  paymentStartDate
                  paymentEndDate
                  properties {
                    id
                  }
                  paymentFrequency
                  price
                  discount
                  billingMethod
                  automatedBilling
                  payments {
                    id
                    invoice
                    invoice
                    amountPaid
                    amountDue
                    date
                    invoicePeriodStartDate
                    invoicePeriodEndDate
                    dueDate
                    paymentMethod
                    hospitalityContract {
                      id
                    }
                  }
                }
            }
          }
        }
        """
    }
    
    private static func createProductionReport(input: Input) -> String? {
        guard let createReportInput = input as? CreateProductionReportInput else {
            NSLog("Couldn't cast input to CreateProductionReportInput.  Please make sure your input matches the mutation's required input.")
            return nil
        }
        let inputString =  """
            mutation {
                createProductionReport(input:{
                    \(createReportInput.formatted)
                }) {
                    productionReport {
                        id
                        date
                        barsProduced
                        soapmakersWorked
                        soapmakerHours
                        soapPhotos
                        media
                    }
                }
            }
        """
        return inputString
    }
    
    private static func updateProductionReport(input: Input) -> String? {
        guard let updateReportInput = input as? UpdateProductionReportInput else {
            NSLog("Couldn't cast input to UpdateProductionReportInput.  Please make sure your input matches the mutation's required input.")
            return nil
        }
        let inputString = """
            mutation {
                updateProductionReport(input:{
                    \(updateReportInput.formatted)
                }) {
                    productionReport {
                        id
                        date
                        barsProduced
                        soapmakersWorked
                        soapmakerHours
                        soapPhotos
                        media
                    }
                }
            }
        """
        return inputString
    }

    private static func deleteProductionReport(input: Input) -> String? {
        guard let id = input as? DeleteProductionReportInput else {
            NSLog("Couldn't cast input to DeleteProductionReportInput.  Please make sure your input matches the mutation's required input.")
            return nil
        }
        let inputString = """
        mutation {
            deleteProductionReport(input:{
                \(id.formatted)
            }) {
                success
                error
            }
        }
        """
        return inputString
    }
}
