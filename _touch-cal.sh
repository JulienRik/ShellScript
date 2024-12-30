#!/bin/bash

# Install required packages
sudo apt-get install -y xserver-xorg-input-evdev xinput-calibrator
if [ $? -ne 0 ]; then
    echo "Installation failed. Please check the possible problems."
    exit 1
fi

# Copy the configuration file
sudo cp -rf /usr/share/X11/xorg.conf.d/10-evdev.conf /usr/share/X11/xorg.conf.d/45-evdev.conf

# Append the calibration configuration
sudo bash -c 'cat << EOF > /usr/share/X11/xorg.conf.d/99-calibration.conf
Section "InputClass"
        Identifier      "calibration"
        MatchProduct    "ADS7846 Touchscreen"
        Option  "Calibration"   "73 4007 3976 84"
        Option  "SwapAxes"      "1"
        Option "EmulateThirdButton" "1"
        Option "EmulateThirdButtonTimeout" "1000"
        Option "EmulateThirdButtonMoveThreshold" "300"
EndSection
EOF'

echo "Configuration completed successfully."

# Keep the terminal open
echo "Press any key to exit..."
read -n 1 -s