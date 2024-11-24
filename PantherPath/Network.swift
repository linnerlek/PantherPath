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

struct Train: Identifiable, Codable {
    var id: String { station }  // Using station as the unique identifier
    var station: String
    var destination: String
    var direction: String
    var eventTime: String
    var line: String
    var nextArr: String
    var waitingTime: String
    
    enum CodingKeys: String, CodingKey {
        case station = "STATION"
        case destination = "DESTINATION"
        case direction = "DIRECTION"
        case eventTime = "EVENT_TIME"
        case line = "LINE"
        case nextArr = "NEXT_ARR"
        case waitingTime = "WAITING_TIME"
    }
}


class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    // Request a Buddy
    func requestBuddy(campusID: String, fromLocation: String, toLocation: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5002/request-buddy") else {
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
            print("Failed to serialize JSON: \(error.localizedDescription)")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making request: \(error.localizedDescription)")
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
                print("Failed to decode response: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }

    // Get Last Buddy Request
    func getLastRequest(campusID: String, completion: @escaping (GetRequestResponse?) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5002/get-request?campusID=\(campusID)") else {
            print("Invalid URL for retrieving last request.")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error making request: \(error.localizedDescription)")
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
                print("Decoded response: \(response)")
                completion(response)
            } catch {
                print("Failed to decode response: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }

    // Remove Buddy from Queue
    func removeBuddyFromQueue(fromLocation: String, toLocation: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5002/remove-buddy") else {
            print("Invalid URL for removing buddy.")
            completion(false, nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = [
            "fromLocation": fromLocation,
            "toLocation": toLocation
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to serialize JSON: \(error.localizedDescription)")
            completion(false, error)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making request: \(error.localizedDescription)")
                completion(false, error)
                return
            }

            guard let data = data else {
                print("No data received from server.")
                completion(false, nil)
                return
            }

            // Check response status or decode the success response if needed
            let success = (response as? HTTPURLResponse)?.statusCode == 200
            completion(success, nil)
        }.resume()
    }
    
    // Fetch MARTA train data
    func getTrainInfo(destination: String, completion: @escaping (Result<[Train], Error>) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5001/get-train-info?destination=\(destination)") else {
            print("Invalid URL for getting train info.")
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error making request: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received from server.")
                completion(.failure(NetworkError.noData))
                return
            }

            // Print raw JSON data for debugging
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                print("Raw JSON response: \(json)")
            }

            do {
                let response = try JSONDecoder().decode([Train].self, from: data)
                completion(.success(response))
            } catch {
                print("Failed to decode response: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }

}

enum NetworkError: Error {
    case invalidURL
    case noData
}
