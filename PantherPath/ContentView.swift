//
//  ContentView.swift
//  PantherPath
//
//  Created by Linn on 11/22/24.
//

import SwiftUI
import WebKit
import UIKit

struct ContentView: View {
    @State private var showLogin = false

    var body: some View {
        VStack(spacing: 0) {
            WebView(url: URL(string: "https://gsu.passiogo.com/?zoom=14.3&lat=33.746852&lng=-84.387904")!)
                .frame(height: 450)
            
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Button(action: {
                            showLogin = true
                        }) {
                            MenuButtonLabel(title: "Walking Buddy")
                        }
                        .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)

                        MenuButtonLabel(title: "MARTA")
                            .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                    }
                    
                    HStack(spacing: 0) {
                        MenuButtonLabel(title: "Parking Spot Tracker")
                            .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)

                        MenuButtonLabel(title: "SOS")
                            .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                    }
                }
            }
            .frame(height: 300)
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView(showLogin: $showLogin)
        }
    }
}

struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

#Preview {
    ContentView()
}

