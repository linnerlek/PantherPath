#
//  WalkingBuddyBackend.py
//  PantherPath
//
//  Created by ethan ngo on 11/23/24.
//

from flask import Flask, request, jsonify
from flaskcors import CORS
import sqlite3

app = Flask(__name__)
CORS(app)  # Allow cross-origin requests for Swift

#Initialize the database
def initdb():
    conn = sqlite3.connect('walkingbuddy.db')
    c = conn.cursor()
    c.execute('''
        CREATE TABLE IF NOT EXISTS requests (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            campusid TEXT NOT NULL,
            from_location TEXT NOT NULL,
            to_location TEXT NOT NULL,
            wait_time TEXT NOT NULL
        )
    ''')
    conn.commit()
    conn.close()

@app.route('/request-buddy', methods=['POST'])
def request_buddy():
    data = request.json
    campus_id = data['campusID']
    from_location = data['fromLocation']
    to_location = data['toLocation']

    # Simulate wait time logic (improve this later w the updated passiogo functions / fetches)
    wait_time = "5 minutes"

    # Save to the database
    conn = sqlite3.connect('walking_buddy.db')
    c = conn.cursor()
    c.execute('''
        INSERT INTO requests (campus_id, from_location, to_location, wait_time)
        VALUES (?, ?, ?, ?)
    ''', (campus_id, from_location, to_location, wait_time))
    conn.commit()
    conn.close()

    return jsonify({"message": "Buddy requested", "waitTime": wait_time})

@app.route('/get-request', methods=['GET'])
def get_request():
    campus_id = request.args.get('campusID')
    
    conn = sqlite3.connect('walking_buddy.db')
    c = conn.cursor()
    c.execute('''
        SELECT from_location, to_location, wait_time 
        FROM requests 
        WHERE campus_id = ?
        ORDER BY id DESC LIMIT 1
    ''', (campus_id,))
    result = c.fetchone()
    conn.close()

    if result:
        return jsonify({
            "fromLocation": result[0],
            "toLocation": result[1],
            "waitTime": result[2]
        })
    else:
        return jsonify({"message": "No previous requests found"}), 404

if __name == '__main':
    init_db()
    app.run(debug=True)
