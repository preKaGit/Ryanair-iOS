//
//  Itineraries.swift
//  RyanairMobileTest
//
//  Created by Marcus Presa Käld
//

struct Itineraries: Decodable {
    let currency: String
    let serverTimeUTC: String
    let currPrecision: Int
    let trips: [Trip]
}

struct Trip: Decodable {
    let origin: String
    let destination: String
    let dates: [TripDate]
}

struct TripDate: Decodable {
    let dateOut: String
    let flights: [Flight]
}

struct Flight: Decodable {
    let time: [String]
    let regularFare: FareContainer?
    let faresLeft: Int?
    let timeUTC: [String]?
    let duration: String?
    let flightNumber: String?
    let infantsLeft: Int?
    let flightKey: String?
    let businessFare: FareContainer?
}

struct FareContainer: Decodable {
    let fareKey: String
    let fareClass: String?
    let fares: [Fare]
}

struct Fare: Decodable {
    let amount: Double
    let count: Int
    let type: String
    let hasDiscount: Bool
    let publishedFare: Double
}
