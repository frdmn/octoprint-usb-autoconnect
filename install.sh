#!/bin/bash

# Copy script
cp octoprint_usb_restart_firmware /usr/local/bin/octoprint_usb_restart_firmware

# Create systemd service
cp octoprint_usb_restart_firmware.service  /etc/systemd/system/octoprint_usb_restart_firmware.service

# Create Rule
cp 40-octoprint_usb_restart_firmware.rules /etc/udev/rules.d/40-octoprint_usb_restart_firmware.rules

# Enable & start service
systemctl enable octoprint_usb_restart_firmware
systemctl start octoprint_usb_restart_firmware

