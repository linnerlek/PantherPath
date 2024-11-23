//
//  LoginView.swift
//  GSHacks
//
//  Created by Linn on 11/22/24.
//

import SwiftUI

struct LoginView: View {
    @Binding var showLogin: Bool
    @State private var campusID = ""
    @State private var showWalkingBuddyView = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Log in with CampusID")
                .font(.title)
                .padding()
            
            TextField("Enter CampusID", text: $campusID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.default)
            
            Button("Log In") {
                if !campusID.isEmpty {
                    showWalkingBuddyView = true
                }
            }
            .padding()
            .background(Color.gsuBlue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Button("Cancel") {
                showLogin = false
            }
            .padding(.top, 40)
            .foregroundColor(.red)
        }
        .padding()
        .fullScreenCover(isPresented: $showWalkingBuddyView) {
            WalkingBuddyView(showWalkingBuddyView: $showWalkingBuddyView)
        }
    }
}

