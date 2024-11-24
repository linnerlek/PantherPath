import SwiftUI
import UIKit
import WebKit

struct MartaView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("MARTA FOR GSU")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
                .navigationBarTitle("MARTA FOR GSU")
            
            Button(action: {
                presentationMode.wrappedValue.dismiss() // Dismiss the current view
            }) {
                Text("Close")
                    .font(.title2)
                    .foregroundColor(.red)
                    .padding()
            }
            .padding(.bottom, 30)
            
            NavigationLink(destination: WebViewWrapper()) {
                Text("Open MARTA Website")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
        }
    }
}

// Wrapper for UIViewController to use WKWebView in SwiftUI
struct WebViewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> WebViewController {
        WebViewController()
    }
    
    func updateUIViewController(_ uiViewController: WebViewController, context: Context) {
        // No updates needed
    }
}

//Basic webview function (not working)
class WebViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let myURL = URL(string: "https://www.itsmarta.com/Georgia-State.aspx") {
            let myRequest = URLRequest(url: myURL)
            webView.load(myRequest)
        }
    }
}
