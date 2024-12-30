#!/bin/bash

success_count=0
target="google.com"
log_file="ping_log17.txt"

# Log-Datei initialisieren
echo "Ping-Log gestartet am $(date "+%Y-%m-%d %H:%M:%S")" > "$log_file"

while [ $success_count -lt 10 ]; do
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    if ping -c 1 $target &> /dev/null; then
        success_count=$((success_count + 1))
        echo "$target -> $timestamp: Erfolgreich: $success_count/10" | tee -a "$log_file"
    else
        echo "$timestamp: Ping $target fehlgeschlagen. Versuche erneut..." | tee -a "$log_file"
    fi
    sleep 60
done

echo "$(date "+%Y-%m-%d %H:%M:%S"): Ping war 10-mal erfolgreich!" | tee -a "$log_file"
