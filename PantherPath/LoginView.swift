//
//  LoginView.swift
//  PantherPath
//
//  Created by Linn on 11/22/24.
//

import SwiftUI

struct LoginView: View {
    @Binding var showLogin: Bool
    @State private var campusID = ""
    @State private var showWalkingBuddyView = false
    @State private var showBuddyRequestView = false
    @State private var fromLocation: String = ""
    @State private var toLocation: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Log in with CampusID")
                .font(.title)
                .padding()

            TextField("Enter CampusID", text: $campusID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.default)

            if isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }

            Button("Log In") {
                if !campusID.isEmpty {
                    // Show loading indicator
                    isLoading = true
                    errorMessage = nil
                    
                    // Make API call to check for existing requests
                    NetworkManager.shared.getLastRequest(campusID: campusID) { response in
                        DispatchQueue.main.async {
                            isLoading = false
                            
                            if let response = response {
                                // If data exists, prepare to navigate to BuddyRequest view
                                print("Found existing request: \(response)")
                                fromLocation = response.fromLocation
                                toLocation = response.toLocation
                                showBuddyRequestView = true
                            } else {
                                // No existing data, navigate to WalkingBuddyView
                                print("No existing request, navigating to WalkingBuddyView.")
                                showWalkingBuddyView = true
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Cancel") {
                showLogin = false
            }
            .padding(.top, 40)
            .foregroundColor(.red)
        }
        .padding()
        // Navigate to WalkingBuddyView if needed
        .fullScreenCover(isPresented: $showWalkingBuddyView) {
            WalkingBuddyView(showWalkingBuddyView: $showWalkingBuddyView, campusID: campusID)
        }
        // Navigate to BuddyRequest if data exists
        .fullScreenCover(isPresented: $showBuddyRequestView) {
            BuddyRequest(fromLocation: $fromLocation, toLocation: $toLocation)
        }
    }
}

