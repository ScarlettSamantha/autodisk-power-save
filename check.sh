#!/bin/bash

# Check power state of all drives and display with emojis
for drive in /sys/block/*; do
    dev=$(basename "$drive")
    [[ "$dev" =~ loop|ram ]] && continue
    power_state=$(cat "/sys/block/$dev/device/power/control")
    if [[ "$power_state" == "auto" ]]; then
        echo -e "$dev: 🌙  Power Saving Enabled (auto)"
    else
        echo -e "$dev: ⚡  Power Saving Disabled (on)"
    fi
done

# Reload udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger

# Verify current power settings for all drives
for drive in /sys/block/*; do
    dev=$(basename "$drive")
    echo "$dev: $(cat /sys/block/$dev/device/power/control)"
done
