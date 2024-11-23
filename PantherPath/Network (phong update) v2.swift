//
//  Network.swift
//  PantherPath
//
//  Created by ethan ngo on 11/23/24.
//

import Foundation

struct RequestBuddyResponse: Codable {
    let message: String
    let waitTime: String
}

struct GetRequestResponse: Codable {
    let fromLocation: String
    let toLocation: String
    let waitTime: String
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func requestBuddy(campusID: String, fromLocation: String, toLocation: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/request-buddy") else {
            print("Invalid URL for requesting a buddy.")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = [
            "campusID": campusID,
            "fromLocation": fromLocation,
            "toLocation": toLocation
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to serialize JSON: (error.localizedDescription)")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making request: (error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received from server.")
                completion(nil)
                return
            }

            do {
                let response = try JSONDecoder().decode(RequestBuddyResponse.self, from: data)
                completion(response.waitTime)
            } catch {
                print("Failed to decode response: (error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }

    func getLastRequest(campusID: String, completion: @escaping (GetRequestResponse?) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/get-request?campusID=\(campusID)") else {
            print("Invalid URL for retrieving last request.")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error making request: (error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received from server.")
                completion(nil)
                return
            }

            do {
                let response = try JSONDecoder().decode(GetRequestResponse.self, from: data)
                completion(response)
            } catch {
                print("Failed to decode response: (error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}
