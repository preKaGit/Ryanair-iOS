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
    let apiClient: APIClient
    
    var isSearchEnabled: Bool {
        flightSearchParams != nil
    }
    
    private var store: UserDefaultsRouteSelectionStore
    
    init(
        apiClient: APIClient = APIClient.shared,
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
    
    func performSearch() async  {
        guard let params = flightSearchParams else {
            return
        }
        isSearching = true
        do {
            var result = try await apiClient.fetchItineraries(params: params)

            self.searchResult = result

            if (filteredResult?.trips.isEmpty ?? true) {
                error = AlertMessage(text: "No flights found for the selected route and date.")
                showResults = false
            } else {
                showResults = true
            }
            isSearching = false
        } catch {
            self.error = AlertMessage(text: error.localizedDescription)
        }
    }
}

extension SearchViewModel {
    var filteredResult: Itineraries? {
        guard let r = searchResult else { return nil }

        let filteredTrips: [Trip] = r.trips.compactMap { trip in
            let filteredDates: [TripDate] = trip.dates.compactMap { date in
                let flights = date.flights.filter { ($0.faresLeft ?? 0) > 0 }
                return flights.isEmpty ? nil : TripDate(dateOut: date.dateOut, flights: flights)
            }
            return filteredDates.isEmpty ? nil : Trip(origin: trip.origin, destination: trip.destination, dates: filteredDates)
        }

        return Itineraries(currency: r.currency,
                           serverTimeUTC: r.serverTimeUTC,
                           currPrecision: r.currPrecision,
                           trips: filteredTrips)
    }
}

extension SearchViewModel {
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
