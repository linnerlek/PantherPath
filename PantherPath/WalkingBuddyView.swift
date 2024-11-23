//
//  WalkingBuddyView.swift
//  GSHacks
//
//  Created by Linn on 11/22/24.
//

import SwiftUI

struct WalkingBuddyView: View {
    @Binding var showWalkingBuddyView: Bool
    @State private var fromLocation = "Library"
    @State private var toLocation = "Parking Deck"
    @State private var locations = ["Library", "Gym", "Dining Hall", "Parking Deck", "Dorms"]
    @State private var buddyRequested = false
    
    var body: some View {
        VStack(spacing: 20) {
            if buddyRequested {
                Text("Buddy requested...")
                    .font(.title)
                    .padding()
                
                Text("Estimated wait: 5 minutes")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
                
                Button("Back to Menu") {
                    showWalkingBuddyView = false
                }
                .padding()
                .foregroundColor(.blue)
                
            } else {
                Text("Request a Walking Buddy")
                    .font(.title)
                    .padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("From:")
                        .font(.headline)
                    
                    Picker("Select Starting Location", selection: $fromLocation) {
                        ForEach(locations, id: \.self) { location in
                            Text(location)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.gsuBlue.opacity(0.1))
                    .cornerRadius(10)
                    
                    Text("To:")
                        .font(.headline)
                    
                    Picker("Select Destination", selection: $toLocation) {
                        ForEach(locations, id: \.self) { location in
                            Text(location)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.gsuBlue.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Button("Request Buddy") {
                    // Toggle buddyRequested to show confirmation screen
                    buddyRequested = true
                }
                .padding()
                .background(Color.gsuBlue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Back") {
                    showWalkingBuddyView = false
                }
                .padding(.top, 40)
                .foregroundColor(.red)
            }
        }
        .padding()
        .animation(.easeInOut, value: buddyRequested) // Smooth transition
    }
}
