#!/bin/bash

# Configuration variables
target="google.com"
success_count=0
max_success=10
sleep_interval=300
log_file="$(date "+%Y-%m-%d %H:%M:%S")_ping-log.txt"

# Get ISP name
isp_name=$(curl -s https://ipinfo.io/org | cut -d ' ' -f 2-)

# Get router IP (assuming the router is the default gateway)
router_ip="192.168.178.1" # $(netstat -nr | grep '^default' | awk '{print $2}')

# Get Fritz!Box model using a targeted nmap scan
router_info=$(nmap -p 21 --script=banner $router_ip) && echo "$router_info"
router_model=$(echo "$router_info" | grep "FRITZ!Box" | awk -F': ' '{print $2}') && echo "$router_model" || router_model="Unknown"

# Trap Ctrl+C for clean exit
trap 'echo "Script terminated by user" | tee -a "$log_file"; exit 0' INT

# Log-Datei initialisieren
echo "Ping-Log-Start: $(date "+%Y-%m-%d %H:%M:%S")" >"$log_file"
echo "ISP: $isp_name" >>"$log_file"
echo "Router: $router_model ($router_ip)" >>"$log_file"

while true; do
    while [ $success_count -lt $max_success ]; do
        timestamp=$(date "+%m-%d %H:%M:%S")
        if ping -c 1 -W 5 "$target" &>/dev/null; then
            echo "$timestamp: success" | tee -a "$log_file"
            ((success_count++))
        else
            echo "$timestamp:FAILED - Ping $target fehlgeschlagen." | tee -a "$log_file"
        fi
        sleep 1
    done

    echo "$(date "+%Y-%m-%d %H:%M:%S"): Ping war $max_success mal erfolgreich!" | tee -a "$log_file"
    # Run speed test and log the results
    echo "Running speed test..." | tee -a "$log_file"
    speedtest --simple 2>/dev/null | tee -a "$log_file"
    success_count=0 # Reset counter for next iteration
    echo "Sleeping for $sleep_interval seconds..." | tee -a "$log_file"
    sleep $sleep_interval
done
