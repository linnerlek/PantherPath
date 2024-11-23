import SwiftUI
import WebKit
import UIKit

struct ContentView: View {
    @State private var showLogin = false
    @State private var menuHeight: CGFloat = UIScreen.main.bounds.height * 0.2 // Initial menu height (20%)
    @State private var maxHeight: CGFloat = UIScreen.main.bounds.height * 0.9 // 90% of screen height
    @State private var minHeight: CGFloat = UIScreen.main.bounds.height * 0.1 // 10% of screen height
    @GestureState private var dragOffset = CGFloat.zero

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // Background color overlay
                Color("GSUBlue")
                    .ignoresSafeArea()

                // WebView (Map) - always pinned at the top, height adjusts with menu height
                WebView(url: URL(string: "https://gsu.passiogo.com/?zoom=14.3&lat=33.746852&lng=-84.387904")!)
                    .frame(width: geometry.size.width, height: geometry.size.height - menuHeight + 20)
                    .clipped() // Ensures content fits within calculated frame
                
                VStack(spacing: 0) {
                    Spacer() // Push menu to the bottom

                    // Draggable Menu View
                    VStack(spacing: 0) {
                        // Tab to drag the menu
                        Capsule()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 40, height: 6)
                            .padding(10)
                            .gesture(
                                DragGesture()
                                    .updating($dragOffset) { value, state, _ in
                                        state = value.translation.height
                                    }
                                    .onEnded { value in
                                        let dragAmount = value.translation.height
                                        // Adjust menu height within 10%-90% constraints
                                        let newHeight = menuHeight - dragAmount
                                        menuHeight = max(minHeight, min(newHeight, maxHeight))
                                    }
                            )

                        // Menu buttons without extra frame modifiers
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                Button(action: {
                                    showLogin = true
                                }) {
                                    MenuButtonLabel(title: "Walking Buddy")
                                }
                                
                                MenuButtonLabel(title: "MARTA")
                            }
                            
                            HStack(spacing: 0) {
                                MenuButtonLabel(title: "Parking Spot Tracker")
                                
                                MenuButtonLabel(title: "SOS")
                            }
                        }
                    }
                    .frame(height: menuHeight) // Set menu height
                    .background(Color("GSUBlue"))
                    .cornerRadius(20)
                    .offset(y: dragOffset) // Apply drag offset to the menu
                }
                .frame(maxHeight: .infinity, alignment: .bottom) // Anchor the menu to the bottom
            }
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
