//
//  ContentView.swift
//  RyanairMobileTest
//
//  Created by Marcus Presa Käld
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    @State var OriginStationView: Bool = false
    @State var DestinationStationView: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    AirportPickerButton(
                        placeholder: "Origin airport",
                        systemName: "airplane.departure",
                        isPresented: $OriginStationView,
                        selectedAirport: $viewModel.originAirport
                    )
                    
                    AirportPickerButton(
                        placeholder: "Destination airport",
                        systemName: "airplane.arrival",
                        isPresented: $DestinationStationView,
                        selectedAirport: $viewModel.destinationAirport
                    )
                } header: {
                    Text("Choose your flights")
                }
                
                BookingDetailsSection(
                    departureDate: $viewModel.departureDate,
                    adults: $viewModel.adults,
                    children: $viewModel.children,
                    teen: $viewModel.teen
                )
            }
            .listStyle(.insetGrouped)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    if viewModel.isSearching {
                        HStack(spacing: 8) {
                            ProgressView()
                            Text("Searching…")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        SearchButton(
                            isEnabled: viewModel.isSearchEnabled,
                            action: { Task { await viewModel.performSearch() } }
                        )
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .task {
            if viewModel.airports.isEmpty {
                await viewModel.fetchAirports()
            }
        }
        .sheet(isPresented: $OriginStationView) {
            OriginAirportView(
                viewModel: OriginAirportViewModel(stations: viewModel.airports),
                originAirport: $viewModel.originAirport
            )
        }
        .sheet(isPresented: $DestinationStationView) {
            DestinationAirportView(
                viewModel: DestinationAiportViewModel(origin: viewModel.originAirport, stations: viewModel.airports),
                destinationAirport: $viewModel.destinationAirport
            )
        }
        .sheet(isPresented: $viewModel.showResults) {
            SearchResultView(results: viewModel.filteredResult)
        }
        .alert(item: $viewModel.error) { message in
            Alert(
                title: Text("Notice"),
                message: Text(message.text),
                dismissButton: .default(Text("OK")) {
                    viewModel.error = nil
                }
            )
        }
    }
}

struct AirportPickerButton: View {
    let placeholder: String
    let systemName: String
    @Binding var isPresented: Bool
    @Binding var selectedAirport: Station?
    
    var body: some View {
        Button { isPresented = true } label: {
            HStack(spacing: 8) {
                Image(systemName: systemName).opacity(0.6)
                Text(selectedAirport?.displayNameWithCode ?? placeholder)
                    .foregroundColor(selectedAirport == nil ? .secondary : .primary)
            }
            .padding(.horizontal)
            .frame(height: 44)
        }
        .accessibilityValue(selectedAirport?.displayNameWithCode ?? "None selected")
    }
}

struct BookingDetailsSection: View {
    @Binding var departureDate: Date
    @Binding var adults: Int
    @Binding var children: Int
    @Binding var teen: Int
    
    var body: some View {
        Section(header: Text("Booking details")) {
            DatePicker("Departure date", selection: $departureDate, displayedComponents: .date)
            
            Stepper(value: $adults, in: 1...6) {
                HStack {
                    Text("Adults")
                    Spacer()
                    Text("\(adults)")
                }
            }
            Stepper(value: $teen, in: 0...6) {
                HStack {
                    Text("Teen")
                    Spacer()
                    Text("\(teen)")
                }
            }
            Stepper(value: $children, in: 0...6) {
                HStack {
                    Text("Children")
                    Spacer()
                    Text("\(children)")
                }
            }
        }
    }
}

struct SearchButton: View {
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: tap) {
            HStack(spacing: 8) {
              
                Image(systemName: "magnifyingglass")
                
                Text("Search")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .buttonStyle(.borderedProminent)
        .tint(.blue)
        .controlSize(.large)
        .frame(height: 36)
        .disabled(!isEnabled)
        .opacity(!isEnabled ? 0.4 : 1.0)
        .accessibilityHint("Find flights with selected options")
    }
    
    private func tap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        action()
    }
}

#Preview {
    SearchView()
}
