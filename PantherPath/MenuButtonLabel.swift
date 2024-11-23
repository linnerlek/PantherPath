//
//  MenuButtonLabel.swift
//  GSHacks
//
//  Created by Linn on 11/22/24.
//

import SwiftUI

struct MenuButtonLabel: View {
    var title: String
    
    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.gsuBlue)
            .foregroundColor(.white)
            .font(.headline)
    }
}

