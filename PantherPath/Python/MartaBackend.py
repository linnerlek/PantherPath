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

@app.route('/get-train-info', methods=['GET'])
def get_train_info():
    destination = request.args.get('destination', '').lower()
    
    # Check if the 'destination' parameter is provided
    if not destination:
        return jsonify({"error": "Please provide a destination as a query parameter."}), 400

    # Only support 'Georgia State University' as the destination
    if destination == "georgia state university":
        try:
            response = requests.get(MARTA_API_URL, params={'apiKey': API_KEY})
            
            # Check if the request was successful
            if response.status_code == 200:
                all_trains = response.json()
                
                # Filter trains stopping at "Georgia State Station"
                filtered_trains = [
                    train for train in all_trains
                    if "GEORGIA STATE STATION" in train.get("STATION", "").upper()
                ]
                
                print("MARTA API Response GSU:", filtered_trains)
                
                # Returns message if no train routes are running
                if not filtered_trains:
                    return jsonify({"message": "Currently no trains stopping right now."})
                
                return jsonify(filtered_trains)
            else:
                return jsonify({"error": f"API request failed with status code {response.status_code}"}), 500
        
        except requests.RequestException as e:
            # Catch any errors with the API request and return an error message
            return jsonify({"error": f"Failed to fetch data from MARTA API: {str(e)}"}), 500

    else:
        return jsonify({"error": "This app currently only supports 'Georgia State University' as the destination."}), 400
