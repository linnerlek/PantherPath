//
//  EmergencyView.swift
//  PantherPath
//
//  Created by Linn on 11/23/24.
//

import SwiftUI
import MessageUI

struct EmergencyView: View {
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @State private var showAlert = false
    @State private var isCalling = false

    var body: some View {
        VStack {
            Spacer()

            // HELP Button to call the number
            Button(action: {
                if let url = URL(string: "tel://4044133333"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                    isCalling = true
                } else {
                    showAlert = true
                }
            }) {
                Text("GSUPD")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 250, height: 250)
                    .background(Color.gsuBlue)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Unable to initiate the call. Please check your device settings."),
                    dismissButton: .default(Text("OK"))
                )
            }

            Spacer()

            // Close Button to go back to ContentView
            Button(action: {
                presentationMode.wrappedValue.dismiss() // Dismiss the current view
            }) {
                Text("Close")
                    .font(.title2)
                    .foregroundColor(.red)
                    .padding()
            }
            .padding(.bottom, 30)
        }
        .padding()
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}
