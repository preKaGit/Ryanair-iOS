//
//  InboundAirportViewModel.swift
//  RyanairMobileTest
//
//  Created by Marcus Presa Käld
//

import SwiftUI
import Combine

@MainActor
final class DestinationAiportViewModel: ObservableObject {
    @Published var origin: Station?
    @Published var stations: [Station]

    @Published var query: String = ""
    @Published var selectedCountry: String? = nil

    init(origin: Station?, stations: [Station]) {
        self.origin = origin
        self.stations = stations
    }

    private var allowedCodes: Set<String> {
        guard let origin else { return [] }
        return Set(origin.markets.map { $0.code })
    }

    private var allowedStations: [Station] {
        guard !allowedCodes.isEmpty else { return [] }
        return stations.filter { allowedCodes.contains($0.code) }
    }

    var filteredStations: [Station] {
        let byCountry = selectedCountry == nil
            ? allowedStations
            : allowedStations.filter { $0.countryName == selectedCountry }

        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return byCountry }

        let lower = q.lowercased()
        return byCountry.filter { s in
            s.name.lowercased().contains(lower)
            || s.code.lowercased().contains(lower)
            || (s.alias ?? []).contains { $0.lowercased().contains(lower) }
        }
    }

    var groupedByCountry: [(country: String, stations: [Station])] {
        groupStationsByCountry(filteredStations)
    }

    var shouldShowPickOriginEmptyState: Bool { origin == nil }
    var noDestinationsForOrigin: Bool { origin != nil && groupedByCountry.isEmpty }
}
