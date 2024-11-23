//
//  BuddyRequest.swift
//  GSHacks
//
//  Created by Linn on 11/22/24.
//

import SwiftUI

struct BuddyRequest: View {
    var body: some View {
        VStack {
            Text("Buddy Requested!")
                .font(.title)
                .padding()

            Text("Estimated Wait Time: 5 minutes")
                .font(.subheadline)
                .padding()

            // Optionally add more info or a button to go back or exit
        }
        .padding()
    }
}
