#!/bin/bash

# Configuration variables
target="google.com"
success_count=0
max_success=10
sleep_interval=300
log_file="$(date "+%Y-%m-%d %H:%M:%S")_ping-log.txt"
fetch_isp_name=true

# Get ISP name
if [ "$fetch_isp_name" = true ]; then
    isp_name=$(curl -s https://ipinfo.io/org | cut -d ' ' -f 2-)
    echo "ISP Name: $isp_name"
else
router_ip=$(ip route | grep default | awk '{print $3}')
    echo "ISP Name fetching is disabled"
fi

# Get router IP (assuming the router is the default gateway)
router_ip=$(netstat -nr | grep '^default' | awk '{print $2}')
echo "Router IP: $router_ip"

# Configuration variable to make nmap scan optional
fetch_router_info=true

if [ "$fetch_router_info" = true ]; then
    # Get Fritz!Box model using a targeted nmap scan
    router_info=$(nmap --script=banner $router_ip)
    echo "Router Info: $router_info"

    router_model=$(echo "$router_info" | grep "FRITZ!Box" | awk -F': ' '{print $2}')
    if [ -z "$router_model" ]; then
        echo "Router Model: Not found or unsupported router"
        router_model="Unknown"
    else
        echo "Router Model: $router_model"
    fi
else
    router_model="Not fetched"
    echo "Router Info fetching is disabled"
fi

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
        sleep 10
    done

    echo "$(date "+%Y-%m-%d %H:%M:%S"): Ping war $max_success mal erfolgreich!" | tee -a "$log_file"
    # Run speed test and log the results
    echo "Running speed test..." | tee -a "$log_file"
    # speedtest 2>/dev/null | tee -a "$log_file"
    speedtest | tee -a "$log_file"
    success_count=0 # Reset counter for next iteration
    echo "Sleeping for $sleep_interval seconds..." | tee -a "$log_file"
    sleep $sleep_interval
done
