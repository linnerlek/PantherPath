#
#  MartaBackend.py
#  PantherPath
#
#  Created by ethan ngo on 11/23/24.
#

from flask import Flask, request, jsonify
from flask_cors import CORS
import requests

app = Flask(__name__)
CORS(app)

# Use the provided API key
API_KEY = 'd5b7aae1-1c03-4a7e-874b-caf3b8e19c4b'

# MARTA API URL endpoint for real-time train arrival data
MARTA_API_URL = "https://developerservices.itsmarta.com:18096/itsmarta/railrealtimearrivals/traindata"

# List of nearby stations
NEARBY_STATIONS = [
    "GEORGIA STATE STATION",
    "FIVE POINTS STATION",
    "PEACHTREE CENTER STATION"
]

@app.route('/get-train-info', methods=['GET'])
def get_train_info():
    destination = request.args.get('destination', '').lower()
    
    # Check if the 'destination' parameter is provided
    if not destination:
        return jsonify({"error": "Please provide a destination as a query parameter."}), 400

    if destination == "georgia state university":
        response = requests.get(MARTA_API_URL, params={'apiKey': API_KEY})
        if response.status_code == 200:
            all_trains = response.json()

            # Filter trains stopping at Georgia State Station or nearby stations
            filtered_trains = [
                {
                    "STATION": train.get("STATION"),
                    "DESTINATION": train.get("DESTINATION"),
                    "DIRECTION": train.get("DIRECTION"),
                    "EVENT_TIME": train.get("EVENT_TIME"),
                    "LINE": train.get("LINE"),
                    "NEXT_ARR": train.get("NEXT_ARR"),
                    "WAITING_TIME": train.get("WAITING_TIME")
                }
                for train in all_trains
                if any(
                    station in train.get("STATION", "").upper() for station in NEARBY_STATIONS
                )
            ]
            
            # Return a message if no trains are running at Georgia State or nearby stations
            if not filtered_trains:
                return jsonify({"message": "Currently no trains stopping at Georgia State or nearby stations."})
            
            return jsonify(filtered_trains)
        else:
            return jsonify({"error": f"API request failed with status code {response.status_code}"}), 500
    else:
        return jsonify({"error": "This app currently only supports 'Georgia State University' as the destination."}), 400
