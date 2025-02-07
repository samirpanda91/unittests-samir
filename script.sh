PROCESS_COUNT=$(ps -p "$PID" --no-headers | wc -l)

if [ "$PROCESS_COUNT" -gt 0 ]; then
  echo "Process with PID $PID is running."
else
  echo "No process found with PID $PID."
fi