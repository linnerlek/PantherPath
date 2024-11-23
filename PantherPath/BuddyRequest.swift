//
//  BuddyRequest.swift
//  GSHacks
//
//  Created by Linn on 11/22/24.
//

import SwiftUI

struct BuddyRequest: View {
    @Binding var fromLocation: String
    @Binding var toLocation: String
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @State private var isRemoving = false // To handle removal state
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            Text("Buddy Requested!")
                .font(.title)
                .padding()

            Text("From: \(fromLocation)")
                .font(.subheadline)
                .padding()

            Text("To: \(toLocation)")
                .font(.subheadline)
                .padding()

            Text("Estimated Wait Time: 5 minutes")
                .font(.subheadline)
                .padding()

            Spacer()

            // Close Button
            Button(action: {
                print("Dismissing the view")
                presentationMode.wrappedValue.dismiss() // Dismiss the current view
            }) {
                Text("Close")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            .padding(.horizontal)


            // Remove from Queue Button
            Button(action: removeFromQueue) {
                Text("Remove from Queue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            // Display error message if removal fails
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
        }
        .padding()
        .navigationBarHidden(true)
        .onAppear {
            // Debugging: Check if data is correctly passed
            print("BuddyRequest View appeared with From: \(fromLocation), To: \(toLocation)")
        }
    }

    private func removeFromQueue() {
        isRemoving = true
        print("Removing from queue: \(fromLocation), \(toLocation)")
        NetworkManager.shared.removeBuddyFromQueue(fromLocation: fromLocation, toLocation: toLocation) { success, error in
            DispatchQueue.main.async {
                isRemoving = false
                if let error = error {
                    errorMessage = "Failed to remove from queue: \(error.localizedDescription)"
                    print("Error removing from queue: \(error.localizedDescription)")
                } else if success {
                    // On success, dismiss the view
                    print("Successfully removed from queue, dismissing view.")
                    presentationMode.wrappedValue.dismiss()
                } else {
                    errorMessage = "Failed to remove from queue. Please try again."
                }
            }
        }
    }

}
