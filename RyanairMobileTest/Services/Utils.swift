//
//  Utils.swift
//  RyanairMobileTest
//
//  Created by Marcus Presa Käld
//

import Foundation

func groupStationsByCountry(_ stations: [Station]) -> [(country: String, stations: [Station])] {
    let filtered = stations.filter { !$0.markets.isEmpty }

    let groups = Dictionary(grouping: filtered, by: { $0.countryName })
    return groups
        .map { (country: $0.key, stations: $0.value.sorted { $0.name < $1.name }) }
        .sorted { $0.country < $1.country }
}

struct AlertMessage: Identifiable {
    let id = UUID()
    let text: String
}

struct FareItem: Identifiable {
    let id = UUID()
    let kind: String
    let fare: Fare
}


public enum PriceFormatter {
    static func label(amount: Double, currency: String) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = currency
        return f.string(from: amount as NSNumber) ?? "\(amount) \(currency)"
    }
}

public func splitDateAndTime(from iso: String) -> (date: String, time: String)? {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withFullDate, .withTime,
                                  .withDashSeparatorInDate,
                                  .withColonSeparatorInTime]

    guard let dateObj = isoFormatter.date(from: iso) else {
        return nil
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateStr = dateFormatter.string(from: dateObj)

    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "HH:mm"
    let timeStr = timeFormatter.string(from: dateObj)

    return (date: dateStr, time: timeStr)
}
