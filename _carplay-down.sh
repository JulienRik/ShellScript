#!/bin/bash
curl https://www.bluewavestudio.io/cpa49f1d1a0428c1b80/1azza00d0a88e9f/hbc199d09849ad/bws_autobox_plugin.zip --output /home/pi/bws_autobox_plugin.zip

if [ $? -ne 0 ]; then
    echo "Download failed. Please check the possible problems."
    exit 1
fi

echo "Download completed successfully."

# Keep the terminal open
echo "Press any key to exit..."
read -n 1 -s