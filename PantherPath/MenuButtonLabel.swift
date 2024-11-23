//
//  MenuButtonLabel.swift
//  PantherPath
//
//  Created by Linn on 11/22/24.
//

import SwiftUI

struct MenuButtonLabel: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.title2)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("GSUBlue")) // Use correct color asset
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(5) // Adjust padding as needed
    }
}

