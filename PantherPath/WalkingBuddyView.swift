//
//  WalkingBuddyView.swift
//  GSHacks
//
//  Created by Linn on 11/22/24.
//



import SwiftUI

struct WalkingBuddyView: View {
    @Binding var showWalkingBuddyView: Bool
    @State private var campusID: String // Now passed from LoginView
    @State private var fromLocation: String = "Library North"
    @State private var toLocation: String = "Parking Deck"
    @State private var locations = ["Library North", "Library South", "Gym", "Dining Hall", "Parking Deck", "Dorms", "Langdale Hall", "Sparks Hall", "Aderhold Center", "Park 55 Place", "Green Space", "Student Recreational Center", "Urban Life", "Student Center West", "Student Center East", "University Lofts", "Patton Hall", "Petit Science Center", "Classroom South"]
    @State private var waitTime: String = "5 minutes" // Static wait time
    @State private var lastRequest: GetRequestResponse?
    @State private var errorMessage: String?
    @State private var showBuddyRequest = false // Controls showing BuddyRequest view

    init(showWalkingBuddyView: Binding<Bool>, campusID: String) {
        self._showWalkingBuddyView = showWalkingBuddyView
        self._campusID = State(initialValue: campusID)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Request a Walking Buddy")
                    .font(.title)
                    .padding(.top, 20)

                // "From" location picker (dropdown)
                Picker("From Location", selection: $fromLocation) {
                    ForEach(locations, id: \.self) { location in
                        Text(location)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)

                // "To" location picker (dropdown)
                Picker("To Location", selection: $toLocation) {
                    ForEach(locations, id: \.self) { location in
                        Text(location)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)

                Button(action: requestBuddy) {
                    Text("Request Buddy")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }

                Divider()
                    .padding(.vertical, 20)
                
                // Show BuddyRequest view when the buddy request is made
                if showBuddyRequest {
                                BuddyRequest(fromLocation: $fromLocation, toLocation: $toLocation)
                                    .transition(.move(edge: .bottom))
                            }

                            Spacer()
                            
                            Button(action: { showWalkingBuddyView = false }) {
                                Text("Close")
                                    .font(.headline)
                                    .foregroundColor(.red)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                        }
            .navigationTitle("Walking Buddy")
            .onAppear {
                fetchLastRequest() // Fetch last request when view appears
            }
            .fullScreenCover(isPresented: $showBuddyRequest) {
                BuddyRequest(fromLocation: $fromLocation, toLocation: $toLocation)
            }
        }
    }

    private func requestBuddy() {
        guard !fromLocation.isEmpty, !toLocation.isEmpty else {
            errorMessage = "Both locations must be selected."
            return
        }

        NetworkManager.shared.requestBuddy(campusID: campusID, fromLocation: fromLocation, toLocation: toLocation) { waitTime in
            DispatchQueue.main.async {
                if let waitTime = waitTime {
                    self.showBuddyRequest = true
                } else {
                    self.errorMessage = "Failed to request buddy. Please try again."
                }
            }
        }
    }

    private func fetchLastRequest() {
        // Simulate fetching the last request (you would normally make an API call here).
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.lastRequest = GetRequestResponse(fromLocation: self.fromLocation, toLocation: self.toLocation, waitTime: "5 minutes")
            self.errorMessage = nil
        }
    }
}
