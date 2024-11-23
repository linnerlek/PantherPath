//
//  WalkingBuddyView.swift
//  GSHacks
//
//  Created by Linn on 11/22/24.
//

//import SwiftUI

//struct WalkingBuddyView: View {
    //@Binding var showWalkingBuddyView: Bool
    //@State private var fromLocation = "Library"
    //@State private var toLocation = "Parking Deck"
    //@State private var locations = ["Library", "Gym", "Dining Hall", "Parking Deck", "Dorms"]
    //@State private var buddyRequested = false
    //new updated variables
    //@State private var campusID = ""
    //@State private var lastRequest: GetRequestResponse?
    //new updated variables^^
    
    //var body: some View {
        //VStack(spacing: 20) {
            //if buddyRequested {
                //Text("Buddy requested...")
                    //.font(.title)
                    //.padding()
                
                //Text("Estimated wait: 5 minutes")
                    //.font(.headline)
                    //.foregroundColor(.gray)
                    //.padding()
                
                //Button("Back to Menu") {
                    //showWalkingBuddyView = false
                //}
                //.padding()
                //.foregroundColor(.blue)
                
            //} else {
                //Text("Request a Walking Buddy")
                    //.font(.title)
                    //.padding()
                
                //VStack(alignment: .leading, spacing: 10) {
                    //Text("From:")
                        //.font(.headline)
                    
                    //Picker("Select Starting Location", selection: $fromLocation) {
                        //ForEach(locations, id: \.self) { location in
                            //Text(location)
                        //}
                    //}
                    //.pickerStyle(MenuPickerStyle())
                    //.padding()
                    //.background(Color.gsuBlue.opacity(0.1))
                    //.cornerRadius(10)
                    
                    //Text("To:")
                        //.font(.headline)
                    
                    //Picker("Select Destination", selection: $toLocation) {
                        //ForEach(locations, id: \.self) { location in
                            //Text(location)
                        //}
                    //}
                    //.pickerStyle(MenuPickerStyle())
                    //.padding()
                    //.background(Color.gsuBlue.opacity(0.1))
                    //.cornerRadius(10)
                //}
                //.padding(.horizontal)
                
                //Button("Request Buddy") {
                    //// Toggle buddyRequested to show confirmation screen
                    //buddyRequested = true
                //}
                //.padding()
                //.background(Color.gsuBlue)
                //.foregroundColor(.white)
                //.cornerRadius(10)
                
                //Button("Back") {
                    //showWalkingBuddyView = false
                //}
                //.padding(.top, 40)
                //.foregroundColor(.red)
            //}
        //}
        //.padding()
        //.animation(.easeInOut, value: buddyRequested) // Smooth transition
    //}
//}


import SwiftUI

struct WalkingBuddyView: View {
    @Binding var showWalkingBuddyView: Bool
    @State private var campusID = ""
    @State private var fromLocation = "Library"
    @State private var toLocation = "Parking Deck"
    @State private var locations = ["Library North", "Library South", "Gym", "Dining Hall", "Parking Deck", "Dorms", "Langdale Hall", "Sparks Hall,", "Aderhold Ceneter", "Park 55 Place", "Green Space", "Student Recreational Center", "Urban Life", "Student Center West", "Student Center East", "Universty Lofts", "Patton Hall", "Petit Science Center", "Classroom South", ]
    @State private var buddyRequested = false
    @State private var lastRequest: GetRequestResponse?

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter CampusID", text: $campusID)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .keyboardType(.numberPad)

            Picker("From", selection: $fromLocation) {
                ForEach(locations, id: \.self) { location in
                    Text(location)
                }
            }
            .pickerStyle(MenuPickerStyle())

            Picker("To", selection: $toLocation) {
                ForEach(locations, id: \.self) { location in
                    Text(location)
                }
            }
            .pickerStyle(MenuPickerStyle())

            Button("Request Buddy") {
                NetworkManager.shared.requestBuddy(campusID: campusID, fromLocation: fromLocation, toLocation: toLocation) { waitTime in
                    if let waitTime = waitTime {
                        self.buddyRequested = true
                        print("Your buddy has been requested! The current wait time: (waitTime)")
                    } else { //make sure you edit this code to make it when it passes a time interval it says this.
                        print("I'm sorry we could not find a buddy for you at the moment.")
                    }
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Button("Save Pathway") {
                NetworkManager.shared.requestBuddy(campusID: campusID, fromLocation: fromLocation, toLocation: toLocation) {
                    waitTime in if waitTime != nil {
                        print("Request save sucessfully.")
                    } else {
                        print("Failed to save the request.")
                    }
                    
                }
            }
            .padding()
            .foregroundColor(.blue)

            Button("Use Prior Pathway") {
                NetworkManager.shared.getLastRequest(campusID: campusID) { response in
                    if let response = response {
                        self.lastRequest = response
                        print("Using prior request: From: \(response.fromLocation), To: \(response.toLocation)")
                    } else {
                        print("No previous requests found for CampusID \(campusID).")
                    }
                }
            }
            .padding()
            .foregroundColor(.blue)

            if let lastRequest = lastRequest {
                Text("Last Request:")
                Text("From: (lastRequest.fromLocation)")
                Text("To: (lastRequest.toLocation)")
                Text("Wait Time: (lastRequest.waitTime)")
            }
        }
        .padding()
    }
}

