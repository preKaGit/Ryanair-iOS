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
            guard let url = APIEndpoints.makeAvailabilityURL(from: params) else {
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

    private static func makeAvailabilityURL(from params: FlightSearchParams) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "nativeapps.ryanair.com"
        components.path = "/api/v4/en-IE/Availability"

        let dateString = DateFormatter.flightDateFormatter.string(from: params.dateOut)

        components.queryItems = [
            URLQueryItem(name: "origin", value: params.origin),
            URLQueryItem(name: "destination", value: params.destination),
            URLQueryItem(name: "dateout", value: dateString),
            URLQueryItem(name: "datein", value: ""),
            URLQueryItem(name: "flexdaysbeforeout", value: "3"),
            URLQueryItem(name: "flexdaysout", value: "3"),
            URLQueryItem(name: "flexdaysbeforein", value: "3"),
            URLQueryItem(name: "flexdaysin", value: "3"),
            URLQueryItem(name: "adt", value: "\(params.adults)"),
            URLQueryItem(name: "teen", value: "\(params.teen)"),
            URLQueryItem(name: "chd", value: "\(params.children)"),
            URLQueryItem(name: "roundtrip", value: "false"),
            URLQueryItem(name: "ToUs", value: "AGREED"),
            URLQueryItem(name: "Disc", value: "0")
        ]

        return components.url
    }
}

