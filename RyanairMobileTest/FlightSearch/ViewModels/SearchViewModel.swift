//
//  AirportViewModel.swift
//  RyanairMobileTest
//
//  Created by Marcus Presa Käld
//
import SwiftUI
import Combine

final class SearchViewModel: ObservableObject {
    
    @Published var airports: [Station] = []
    @Published var error: AlertMessage?
    @Published var destinationAirport: Station?
    @Published var departureDate: Date = Date()
    @Published var adults: Int = 1
    @Published var teen: Int = 0
    @Published var children: Int = 0
    @Published var isSearching: Bool = false
    @Published var showResults = false

    @Published var originAirport: Station? {
        didSet {
            store.originAirport = originAirport
            if oldValue?.code != originAirport?.code {
                destinationAirport = nil
            }
        }
    }
    
    var searchResult: Itineraries?
    
    var isSearchEnabled: Bool {
        guard !isSearching,
              originAirport?.code != nil,
              destinationAirport?.code != nil,
              adults > 0 else { return false }
        return true
    }
    
    private var store: UserDefaultsRouteSelectionStore
    private let apiClient: APIClientProtocol

    init(
        apiClient: APIClientProtocol,
        store: UserDefaultsRouteSelectionStore = UserDefaultsRouteSelectionStore.shared
    ) {
        self.apiClient = apiClient
        self.store = store
    }
    
    func fetchAirports() async {
        do {
            airports = try await apiClient.fetchStations()
        } catch {
            self.error = AlertMessage(text: error.localizedDescription)
        }
    }
    
    func performSearch() async {
        guard let params = flightSearchParams else {
            self.error = AlertMessage(text: "Please select origin, destination, and date before searching.")
            return
        }

        isSearching = true
        defer { isSearching = false }

        do {
            let result = try await apiClient.fetchItineraries(params: params)
            self.searchResult = result

            if let filtered = self.filteredResult, !filtered.trips.isEmpty {
                self.showResults = true
            } else {
                self.error = AlertMessage(text: "No flights found for the selected route and date.")
                self.showResults = false
            }
        } catch {
            self.error = AlertMessage(text: error.localizedDescription)
            self.showResults = false
        }
    }
    
    var filteredResult: Itineraries? {
        guard let result = searchResult else { return nil }

        let filteredTrips: [Trip] = result.trips.compactMap { trip in
            let filteredDates: [TripDate] = trip.dates.compactMap { date in
                let flights = date.flights.filter { ($0.faresLeft ?? 0) > 0 }
                return flights.isEmpty ? nil : TripDate(dateOut: date.dateOut, flights: flights)
            }
            return filteredDates.isEmpty ? nil : Trip(origin: trip.origin, destination: trip.destination, dates: filteredDates)
        }

        return Itineraries(currency: result.currency,
                           serverTimeUTC: result.serverTimeUTC,
                           currPrecision: result.currPrecision,
                           trips: filteredTrips)
    }
    
    var flightSearchParams: FlightSearchParams? {
        guard let origin = originAirport?.code,
              let destination = destinationAirport?.code
        else { return nil }

        return FlightSearchParams(
            origin: origin,
            destination: destination,
            dateOut: departureDate,
            adults: adults,
            teen: teen,
            children: children
        )
    }
}
