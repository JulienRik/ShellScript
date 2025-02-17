#!/bin/bash

# Exit on error
set -e

# Print commands before executing
set -x

# Main script
# Create log directory if it doesn't exist
mkdir -p /var/log/wifi-stats

# Get current date/time for filename
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="/var/log/wifi-stats/wifi_stats_${TIMESTAMP}.log"

# Run command and save output to log file with timestamp
sudo wdutil info | awk '/RSSI:/ {print "RSSI: " $2} /lastTxRate:/ {print "Tx Rate: " $2}' | while read line; do
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $line" | tee -a "$LOG_FILE"
    
    done

# Ask user if they want to open the log file
read -p "Would you like to open the log file? (y/n): " OPEN_LOG

if [ "$OPEN_LOG" = "y" ]; then
    open "$LOG_FILE"
else
    echo "Log file saved to: $LOG_FILE"
done

# Exit successfully
exit 0
