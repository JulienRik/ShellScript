#!/bin/bash
sudo apt install onboard
sudo apt install at-spi2-core

if [ $? -ne 0 ]; then
    echo "Installation failed. Please check the possible problems."
    exit 1
fi

echo "Installation completed successfully."

# Keep the terminal open
echo "Press any key to exit..."
read -n 1 -s