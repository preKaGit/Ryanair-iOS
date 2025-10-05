//
//  AirportsView.swift
//  RyanairMobileTest
//
//  Created by Marcus Presa Käld
//

import SwiftUI

struct OriginAirportView: View {
    @ObservedObject var viewModel: OriginAirportViewModel
    @Binding var originAirport: Station?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isEmptySearchResult {
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        
                        Text("No airports found")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Try a different search term.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .multilineTextAlignment(.center)
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
                                        if originAirport?.code == station.code {
                                            Image(systemName: "checkmark")
                                                .font(.caption)
                                                .foregroundColor(.accentColor)
                                        }
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        originAirport = station
                                        dismiss()
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .searchable(text: $viewModel.query, prompt: "Search airports")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: { Image(systemName: "xmark") }
                        .buttonStyle(.plain)
                }
            }

        }
    }
}
