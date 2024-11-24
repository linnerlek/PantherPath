//
//  MartaView.swift
//  PantherPath
//
//  Created by Linn on 11/22/24.
//

import SwiftUI

struct MartaView: View {
    @Environment(\.presentationMode) var presentationMode  // Add this to handle dismissal
    @State private var trains: [Train] = [] // Array to hold train data
    @State private var isLoading: Bool = false // Loading state
    @State private var errorMessage: String? = nil // Error state
    @State private var expandedStations: Set<String> = [] // Track expanded stations
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if trains.isEmpty {
                    Text("No trains available.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        // Group trains by both station and destination
                        let groupedTrains = groupTrainsByStationAndDestination()
                        
                        // Split stations into Georgia State first and other stations sorted
                        let stations = groupedTrains.keys
                        let georgiaStateFirst = stations.filter { $0 == "Georgia State University" }
                        let otherStations = stations.filter { $0 != "Georgia State University" }.sorted()
                        let allStations = georgiaStateFirst + otherStations

                        ForEach(allStations, id: \.self) { station in
                            VStack(alignment: .leading) {
                                // Station Header (tappable)
                                Button(action: {
                                    toggleStationExpansion(station)
                                }) {
                                    Text(station)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .padding(.vertical, 5)
                                        .foregroundColor(Color.gsuBlue)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading)  // Align left with padding of 15
                                }
                                .background(Color.white)
                                .cornerRadius(12)
                                .padding(.horizontal)
                                
                                // Only show destinations if station is expanded
                                if expandedStations.contains(station) {
                                    // Loop through each destination within the station
                                    ForEach(groupedTrains[station]!.keys.sorted(), id: \.self) { destination in
                                        VStack(alignment: .leading) {
                                            // For each unique train of this destination
                                            ForEach(groupedTrains[station]![destination]!, id: \.id) { train in
                                                TrainCard(train: train)
                                                    .padding(.bottom, 4)
                                            }
                                        }
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("MARTA Tracker")
            .onAppear(perform: fetchTrainData)
        }
    }
    
    private func fetchTrainData() {
        isLoading = true
        errorMessage = nil
        
        NetworkManager.shared.getTrainInfo(destination: "Georgia State University") { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let fetchedTrains):
                    trains = fetchedTrains
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Group trains by station and then by destination, ensuring uniqueness
    private func groupTrainsByStationAndDestination() -> [String: [String: [Train]]] {
        var grouped = [String: [String: [Train]]]()

        for train in trains {
            // Ensure uniqueness: check if train is already added for this station and destination
            if grouped[train.station] == nil {
                grouped[train.station] = [String: [Train]]()
            }
            
            if grouped[train.station]?[train.destination] == nil {
                grouped[train.station]?[train.destination] = [Train]()
            }
            
            // Add the train to the group only if it's unique (no duplicate trains for a station-destination pair)
            if let stationGroup = grouped[train.station],
               let destinationGroup = stationGroup[train.destination],
               !destinationGroup.contains(where: { $0.id == train.id }) {
                grouped[train.station]?[train.destination]?.append(train)
            }

        }
        
        return grouped
    }
    
    // Toggle the expansion of a station
    private func toggleStationExpansion(_ station: String) {
        if expandedStations.contains(station) {
            expandedStations.remove(station)
        } else {
            expandedStations.insert(station)
        }
    }
}



struct TrainCard: View {
    let train: Train
    
    // Convert direction abbreviations to full names
    private func fullDirectionName(for abbreviation: String) -> String {
        switch abbreviation {
        case "N": return "North"
        case "S": return "South"
        case "E": return "East"
        case "W": return "West"
        default: return abbreviation // Default to abbreviation if it's not recognized
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(train.destination)")
                    .font(.headline)
                Text("\(train.line), \(fullDirectionName(for: train.direction))") // Use the full direction name
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(train.waitingTime)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Text("Next: \(train.nextArr)")
                    .font(.caption)
                    .foregroundColor(.black)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .frame(width: UIScreen.main.bounds.width * 0.9)
    }
}

