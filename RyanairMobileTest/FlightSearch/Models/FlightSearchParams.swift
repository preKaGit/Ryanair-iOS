//
//  FlightSearchParams.swift
//  RyanairMobileTest
//
//  Created by Marcus Presa Käld
//

import Foundation

struct FlightSearchParams {
    var origin: String
    var destination: String
    var dateOut: Date
    var adults: Int
    var teen: Int
    var children: Int
    
    var clamped: FlightSearchParams {
        .init(
            origin: origin,
            destination: destination,
            dateOut: dateOut,
            adults: max(1, min(adults, 6)),
            teen: max(0, min(teen, 6)),
            children: max(0, min(children, 6))
        )
    }
}
