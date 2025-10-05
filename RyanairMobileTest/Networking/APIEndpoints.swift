//
//  APIEndPoints.swift
//  RyanairMobileTest
//
//  Created by Marcus Presa Käld
//

import SwiftUI

enum APIEndpoints {
    case stations
    case itineraries(FlightSearchParams)
    
    var url: URL {
        switch self {
        case .stations:
            return URL(string: "https://mobile-testassets-dev.s3.eu-west-1.amazonaws.com/stations.json")!
        case .itineraries(let params):
            guard let url = params.asAvailabilityURL() else {
                fatalError("Invalid URL built from FlightSearchParams")
            }
            return url
        }
    }
    
    var getMethod: String { "GET" }
        
    /// Default headers needed by the API
    var headers: [String: String] {
        [
            "Content-Type": "application/json",
            "client": "ios",
            "client-version": "3.999.0"
        ]
    }
}
