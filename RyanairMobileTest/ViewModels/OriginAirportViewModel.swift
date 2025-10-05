//
//  InboundAirportViewModel.swift
//  RyanairMobileTest
//
//  Created by Marcus Presa Käld
//

import SwiftUI
import Combine

@MainActor
final class OriginAirportViewModel: ObservableObject {
    
    @Published var stations: [Station]
    @Published var query: String = ""

    init(stations: [Station]) {
        self.stations = stations
    }

    var filteredStations: [Station] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return stations }
        let lower = q.lowercased()
        return stations.filter { s in
            s.name.lowercased().contains(lower)
            || s.code.lowercased().contains(lower)
            || (s.alias ?? []).contains { $0.lowercased().contains(lower) }
        }
    }

    var groupedByCountry: [(country: String, stations: [Station])] {
        groupStationsByCountry(filteredStations)
    }

    var isEmptySearchResult: Bool {
        !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && filteredStations.isEmpty
    }
}
