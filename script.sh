#!/bin/bash

# Find the process IDs of the Python scripts
python_pids=$(pgrep -f "python your_python_script.py")

# Iterate through each process ID
for pid in $python_pids; do
  # Send SIGTERM signal to the process
  kill $pid

  # Wait for the process to terminate gracefully
  while kill -0 $pid 2>/dev/null; do
    sleep 1
  done

  echo "Process $pid terminated gracefully."
done

Explanation:
 * Find Process IDs:
   * pgrep -f "python your_python_script.py": This command finds the process IDs of all processes that match the specified pattern. In this case, it searches for processes that are running the Python script with the given name.
 * Iterate and Send Signal:
   * The script iterates through each process ID found in the previous step.
   * kill $pid: This sends the SIGTERM signal to the process. SIGTERM is the standard signal for requesting a process to terminate gracefully. It allows the process to clean up any resources before exiting.
 * Wait for Graceful Termination:
   * kill -0 $pid 2>/dev/null: This command checks if the process is still running. If the process is running, the command will succeed. If the process has terminated, the command will fail. The 2>/dev/null redirects any error output to the null device, preventing it from being displayed on the console.
   * The while loop continues to check if the process is still running every second. If the process is still running, the loop continues. If the process has terminated, the loop exits.
 * Confirmation Message:
   * Once the process has terminated gracefully, the script prints a message indicating that the process has been terminated.
To use this script:
 * Replace your_python_script.py with the actual name of your Python script.
 * Save the script to a file (e.g., stop_script.sh).
 * Make the script executable: chmod +x stop_script.sh
 * Run the script: ./stop_script.sh
This script will send the SIGTERM signal to each running instance of your Python script and wait for them to terminate gracefully before proceeding. This ensures that your Python scripts have a chance to clean up any resources they are using before being terminated.
