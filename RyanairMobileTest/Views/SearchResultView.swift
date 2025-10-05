//
//  ContentView.swift
//  RyanairMobileTest
//
//  Created by Marcus Presa Käld
//

import SwiftUI

struct SearchResultView: View {
    @Environment(\.dismiss) private var dismiss
    
    var results: Itineraries?

    var body: some View {
        NavigationStack {
            List {
                if let itineraries = results {
                    ForEach(itineraries.trips, id: \.origin) { trip in
                        Section(header: Text("\(trip.origin) → \(trip.destination)")) {
                            ForEach(trip.dates, id: \.dateOut) { tripDate in
                                ForEach(tripDate.flights.indices, id: \.self) { idx in
                                    let flight = tripDate.flights[idx]
                                    FlightSummaryRow(flight: flight,
                                                     currency: itineraries.currency)
                                }
                            }
                        }
                    }
                } else {
                    ProgressView("Loading…")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Results")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel("Close")
                }
            }
        }
    }
}

struct FlightSummaryRow: View {
    let flight: Flight
    let currency: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                let depISO = flight.time.first ?? ""
                let arrISO = flight.time.last ?? ""
                if let dep = splitDateAndTime(from: depISO),
                   let arr = splitDateAndTime(from: arrISO) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(dep.time) – \(arr.time)")
                            .font(.headline)
                        Text(dep.date.trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Text("Unknown time")
                        .font(.headline)
                }

                Text(flight.flightNumber ?? "Unknown flight")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if !fareItems.isEmpty {
                VStack(alignment: .trailing, spacing: 6) {
                    ForEach(fareItems) { item in
                        HStack(spacing: 12) {
                            Text("\(item.kind) · \(item.fare.type)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(PriceFormatter.label(amount: item.fare.amount, currency: currency))
                                .font(.subheadline)
                        }
                    }
                }
            } else {
                Text("N/A")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
    
    private var fareItems: [FareItem] {
        var items: [FareItem] = []
        if let fares = flight.regularFare?.fares {
            items.append(contentsOf: fares.map { FareItem(kind: "Regular", fare: $0) })
        }
        if let fares = flight.businessFare?.fares {
            items.append(contentsOf: fares.map { FareItem(kind: "Business", fare: $0) })
        }
        return items
    }
}
