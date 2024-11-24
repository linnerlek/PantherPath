#
#  app.py
#  PantherPath
#
#  Created by Linn on 11/24/24.
#

import signal
import sys
from threading import Thread
import MartaBackend
import WalkingBuddyBackend

# Flag to prevent double execution of the shutdown function
shutdown_called = False

# Function to handle graceful shutdown
def shutdown(signal=None, frame=None):
    global shutdown_called
    if not shutdown_called:
        shutdown_called = True
        print("\nShutting down...")
        sys.exit(0)

# Function to run the MARTA backend
def run_marta_backend():
    MartaBackend.app.run(port=5001, debug=True, use_reloader=False)

# Function to run the Walking Buddy backend
def run_walking_buddy_backend():
    WalkingBuddyBackend.app.run(port=5002, debug=True, use_reloader=False)

if __name__ == '__main__':
    signal.signal(signal.SIGINT, shutdown)
    signal.signal(signal.SIGTERM, shutdown)

    # Create threads for each backend
    marta_thread = Thread(target=run_marta_backend, daemon=True)
    walking_buddy_thread = Thread(target=run_walking_buddy_backend, daemon=True)

    # Start the threads
    marta_thread.start()
    walking_buddy_thread.start()

    print("Servers are running. Press CTRL+C to quit.")

    # Keep the main thread alive and wait for termination signals
    try:
        while True:
            pass
    except (KeyboardInterrupt, SystemExit):
        shutdown()
