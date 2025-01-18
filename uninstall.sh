!/bin/bash

# Remove the udev rule
sudo rm -f /etc/udev/rules.d/85-hdd-spin-down.rules

# Reload udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger

# Disable power saving on all drives
for drive in /sys/block/*; do
    dev=$(basename "$drive")
    [[ "$dev" =~ loop|ram ]] && continue
    echo "on" | sudo tee "/sys/block/$dev/device/power/control" > /dev/null
    echo "$dev: ⚡ Power Saving Disabled"
done

echo "❌ Power-saving mode disabled for all drives."
