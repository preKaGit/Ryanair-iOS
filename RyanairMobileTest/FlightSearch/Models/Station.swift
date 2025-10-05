//
//  Station.swift
//  RyanairMobileTest
//
//  Created by Marcus Presa Käld
//

import Foundation

struct StationResponse: Decodable {
    let stations: [Station]
}

struct Station: Decodable, Encodable {
    let code: String
    let name: String
    let alternateName: String?
    let alias: [String]?
    let countryCode: String
    let countryName: String
    let countryAlias: String?
    let countryGroupCode: String
    let countryGroupName: String
    let timeZoneCode: String
    let latitude: String
    let longitude: String
    let mobileBoardingPass: Bool
    let markets: [Market]
    let notices: String?
    let tripCardImageUrl: String?
}

struct Market: Decodable, Encodable {
    let code: String
    let group: String?
}

extension Station {
    var displayNameWithCode: String {
        "\(name) (\(code))"
    }
}
