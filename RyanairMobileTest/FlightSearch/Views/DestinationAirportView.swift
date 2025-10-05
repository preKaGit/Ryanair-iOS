//
//  InboundAirportView.swift
//  RyanairMobileTest
//
//  Created by Marcus Presa Käld
//
import SwiftUI

struct DestinationAirportView: View {
    @ObservedObject var viewModel: DestinationAiportViewModel
    @Binding var destinationAirport: Station?
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.shouldShowPickOriginEmptyState {
                    EmptyState(icon: "airplane.departure",
                               title: "Select a departure airport first",
                               subtitle: "Then choose your destination.")
                } else if viewModel.noDestinationsForOrigin {
                    EmptyState(icon: "airplane.arrival",
                               title: "No destinations available",
                               subtitle: "Try a different departure airport.")
                } else {
                    List {
                        ForEach(viewModel.groupedByCountry, id: \.country) { group in
                            Section(header: Text(group.country)) {
                                ForEach(group.stations, id: \.code) { station in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(station.name)
                                            Text(station.code)
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        if destinationAirport?.code == station.code {
                                            Image(systemName: "checkmark")
                                                .font(.caption)
                                                .foregroundColor(.accentColor)
                                        }
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        destinationAirport = station
                                        dismiss()
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .searchable(text: $viewModel.query, prompt: "Search destinations")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: { Image(systemName: "xmark") }
                        .buttonStyle(.plain)
                }
            }
        }
    }
}

private struct EmptyState: View {
    let icon: String
    let title: String
    let subtitle: String
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon).font(.largeTitle).foregroundColor(.secondary)
            Text(title).font(.headline).foregroundColor(.secondary)
            Text(subtitle).font(.subheadline).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .multilineTextAlignment(.center)
    }
}
