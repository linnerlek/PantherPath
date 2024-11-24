#
#  WalkingBuddyBackend.py
#  PantherPath
#
#  Created by ethan ngo on 11/23/24.
#


from flask import Flask, request, jsonify
from flask_cors import CORS
import sqlite3

app = Flask(__name__)
CORS(app)  # Allow cross-origin requests for Swift

# Initialize the database
def initdb():
    conn = sqlite3.connect('walkingbuddy.db')
    c = conn.cursor()
    # Drop the existing table (for debugging, remove this in production)
    c.execute('DROP TABLE IF EXISTS requests')
    c.execute('''
        CREATE TABLE requests (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            campus_id TEXT NOT NULL,
            from_location TEXT NOT NULL,
            to_location TEXT NOT NULL
        )
    ''')
    conn.commit()
    conn.close()

# Request Buddy route (POST)
@app.route('/request-buddy', methods=['POST'])
def request_buddy():
    try:
        data = request.json
        print(f"Request data: {data}")  # Debugging

        campus_id = data['campusID']
        from_location = data['fromLocation']
        to_location = data['toLocation']

        # Save to the database
        conn = sqlite3.connect('walkingbuddy.db')
        c = conn.cursor()
        c.execute('''
            INSERT INTO requests (campus_id, from_location, to_location)
            VALUES (?, ?, ?)
        ''', (campus_id, from_location, to_location))
        conn.commit()
        conn.close()

        response = {"message": "Buddy requested", "waitTime": "5 minutes"}
        print(f"Response: {response}")  # Debugging
        return jsonify(response), 200
    except Exception as e:
        print(f"Error: {e}")  # Debugging
        return jsonify({"message": "Failed to request buddy", "error": str(e)}), 500

# Get the last request route (GET)
@app.route('/get-request', methods=['GET'])
def get_request():
    campus_id = request.args.get('campusID')
    print(f"Received campusID: {campus_id}")  # Debugging

    conn = sqlite3.connect('walkingbuddy.db')
    c = conn.cursor()
    c.execute('''
        SELECT from_location, to_location 
        FROM requests 
        WHERE campus_id = ?
        ORDER BY id DESC LIMIT 1
    ''', (campus_id,))
    result = c.fetchone()
    conn.close()

    if result:
        print(f"Query result: {result}")  # Debugging
        return jsonify({
            "fromLocation": result[0],
            "toLocation": result[1],
            "waitTime": "5 minutes"  # Static wait time
        }), 200
    else:
        print("No request found.")  # Debugging
        return jsonify({"message": "No previous requests found"}), 404

# Remove Buddy from Queue route (POST)
@app.route('/remove-buddy', methods=['POST'])
def remove_buddy():
    try:
        data = request.json
        print(f"Remove buddy data: {data}")  # Debugging

        from_location = data['fromLocation']
        to_location = data['toLocation']

        # Remove the request from the database
        conn = sqlite3.connect('walkingbuddy.db')
        c = conn.cursor()
        c.execute('''
            DELETE FROM requests 
            WHERE from_location = ? AND to_location = ?
        ''', (from_location, to_location))
        conn.commit()
        conn.close()

        response = {"message": "Buddy request removed"}
        print(f"Response: {response}")  # Debugging
        return jsonify(response), 200
    except Exception as e:
        print(f"Error: {e}")  # Debugging
        return jsonify({"message": "Failed to remove buddy", "error": str(e)}), 500


initdb()  # Initialize the database
