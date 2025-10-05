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
    
    private static var dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale   = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter
        }()
    
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

extension FlightSearchParams {
    func asAvailabilityURL() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "nativeapps.ryanair.com"
        components.path = "/api/v4/en-IE/Availability"
        
        let dateString = Self.dateFormatter.string(from: dateOut)

        components.queryItems = [
            URLQueryItem(name: "origin", value: origin),
            URLQueryItem(name: "destination", value: destination),
            URLQueryItem(name: "dateout", value: dateString),
            URLQueryItem(name: "datein", value: ""),
            URLQueryItem(name: "flexdaysbeforeout", value: "3"),
            URLQueryItem(name: "flexdaysout", value: "3"),
            URLQueryItem(name: "flexdaysbeforein", value: "3"),
            URLQueryItem(name: "flexdaysin", value: "3"),
            URLQueryItem(name: "adt", value: "\(adults)"),
            URLQueryItem(name: "teen", value: "\(teen)"),
            URLQueryItem(name: "chd", value: "\(children)"),
            URLQueryItem(name: "roundtrip", value: "false"),
            URLQueryItem(name: "ToUs", value: "AGREED"),
            URLQueryItem(name: "Disc", value: "0")
        ]
        return components.url
    }
}
