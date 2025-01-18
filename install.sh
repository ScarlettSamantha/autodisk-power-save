#!/bin/bash

# Get the UUID of the root filesystem
OS_UUID=$(findmnt -no UUID /)

# Create a udev rule to enable power saving on non-OS drives
cat <<EOF | sudo tee /etc/udev/rules.d/85-hdd-spin-down.rules
ACTION=="add|change", KERNEL=="sd*", ENV{ID_FS_UUID}!="$OS_UUID", ATTR{power/control}="auto"
ACTION=="add|change", KERNEL=="nvme*", ENV{ID_FS_UUID}!="$OS_UUID", ATTR{power/control}="auto"
EOF

# Reload udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger

echo "✅ Power-saving mode enabled for non-OS drives."
    