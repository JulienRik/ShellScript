#!/bin/bash

# Pfade der Inpput/Ouput-Ordner werden festgelegt
INPUT_DIR="/Users/julienbohnsack/Downloads/renderings"
OUTPUT_DIR="/Users/julienbohnsack/Downloads/renderings/output_wav"

# Wenn der Output Ordner noch nicht existiert
mkdir -p "$OUTPUT_DIR"

# Schleife für alle wav Dateien in input_dir
for input_file in "$INPUT_DIR"/*.wav; do
    filename=$(basename "$input_file" .wav)
    ffmpeg -i "$input_file" -acodec pcm_s24le "$OUTPUT_DIR/$filename.wav"

    if [ $? -eq 0 ]; then
        echo "Die Konvertierung von $input_file zu $output_dir/$filename.wav war erfolgreich."
    else
        echo "Die Konvertierung von $input_file zu $output_dir/$filename.wav ist fehlgeschlagen."
    fi
done
