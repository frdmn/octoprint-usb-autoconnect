#!/bin/bash

# Copy script & config
cp octoprint-usb-restart-firmware /usr/local/bin/octoprint-usb-restart-firmware
cp octoprint-usb-restart-firmware.conf /usr/local/etc/octoprint-usb-restart-firmware.conf
# Some basic security for the API key
chmod 400 /usr/local/etc/octoprint-usb-restart-firmware.conf 

# Create systemd service
ln -s octoprint-usb-restart-firmware.service  /etc/systemd/system/octoprint-usb-restart-firmware.service

# Create Rule
ln -s 40-octoprint-usb-restart-firmware.rules /etc/udev/rules.d/40-octoprint-usb-restart-firmware.rules

# Enable & start service
udevadm control --reload-rules
systemctl restart systemd-udevd.service
systemctl enable octoprint-usb-restart-firmware
systemctl start octoprint-usb-restart-firmware


