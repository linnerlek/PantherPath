//
//  AppState.swift
//  PantherPath
//
//  Created by Linn on 11/23/24.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    // Shared loading state
    @Published var isLoading: Bool = false
}
