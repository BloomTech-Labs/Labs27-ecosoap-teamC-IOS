//
//  Queries.swift
//  labs-ios-starter
//
//  Created by Karen Rodriguez on 8/12/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.

import Foundation

class Queries: Request {

    var body: String

    var payload: ResponseModel

    var name: String

    private static let collection = [QueryName.userById: Queries.userById,
                                              .propertyById: Queries.propertyById,
                                              .propertiesByUserId: Queries.propertiesByUserId,
                                              .impactStatsByPropertyId: Queries.impactStatsByPropertyId,
                                              .hubByPropertyId: Queries.hubByPropertyId,
                                              .pickupsByPropertyId: Queries.pickupsByPropertyId,
                                              .productionReportsByHubId: Queries.productionReportsByHubId,
                                              .monsterFetch: Queries.monsterFetch]

    private static let payloads: [QueryName: ResponseModel] = [.userById: .user,
                                                               .propertyById: .property,
                                                               .propertiesByUserId: .properties,
                                                               .impactStatsByPropertyId: .impactStats,
                                                               .hubByPropertyId: .hub,
                                                               .pickupsByPropertyId: .pickups,
                                                               .productionReportsByHubId: .productionReports,
                                                               .monsterFetch: .user]

    init?(name: QueryName, id: String) {
        guard let body = Queries.collection[name] else {
            NSLog("Couldn't find this query in the collection. Check your implementation.")
            return nil
        }

        guard let payload = Queries.payloads[name] else {
            NSLog("Couldn't find a matching payload name. Check your implementation.")
            return nil
        }

        self.body = body(id)
        self.payload = payload
        self.name = name.rawValue
    }

    private static func propertiesByUserId(propertyID: String) -> String {
        return """
        {
            propertiesByUserId(input: { userId: "\(propertyID)" }) {
                properties {
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

    private static func userById(userID: String) -> String {
        return """
        {
        userById(input: { userId:  \"\(userID)\" }) {
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
        signupTime
        role
        properties {
            id
        }
        }
        }
        }
        """
    }

    private static func propertyById(propertyID: String) -> String {
        return """
        {
        propertyById(input: {
        propertyId: "\(propertyID)"
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

    private static func impactStatsByPropertyId(propertyID: String) -> String {
        return """
        query {
        impactStatsByPropertyId(input: {
        propertyId: "\(propertyID)"
        }) {
        impactStats {
        soapRecycled
        linensRecycled
        bottlesRecycled
        paperRecycled
        peopleServed
        womenEmployed
        }
        }
        }
        """
    }

    private static func hubByPropertyId(propertyID: String) -> String {
        """
        query {
          hubByPropertyId(input: {
            propertyId: "\(propertyID)"
          }) {
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
          }
        }

        """
    }

    private static func pickupsByPropertyId(propertyID: String) -> String {
        """
        query {
          pickupsByPropertyId(input: {
            propertyId: "\(propertyID)"
          })  {
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
          }
        }

        """
    }
    
    private static func productionReportsByHubId(hubId: String) -> String {
        return """
        query {
            productionReportsByHubId(input: { hubId: "\(hubId)" }) {
                productionReports {
                    id
                    hub {
                        id
                    }
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
    }

    private static func monsterFetch(userID: String) -> String {
        return """
        query {
          userById(input: {
            userId: "\(userID)"
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
                  amountPaid
                }
              }
            }
          }
        }
        """
    }

}
