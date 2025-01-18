#!/bin/bash

# Remove the udev rule
sudo rm -f /etc/udev/rules.d/99-storage-power-save.rules

# Reload udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger

# Function to detect critical devices
is_critical_device() {
    local dev="$1"
    ROOT_DEV=$(findmnt -no SOURCE / | sed -E 's|[0-9]+$||')
    SWAP_DEVICES=$(findmnt -no SOURCE -t swap | sed -E 's|[0-9]+$||')
    BOOT_DEVICES=$(findmnt -no SOURCE /boot /boot/efi 2>/dev/null | sed -E 's|[0-9]+$||')

    if [[ "$dev" == "$ROOT_DEV" ]] || [[ "$SWAP_DEVICES" =~ "$dev" ]] || [[ "$BOOT_DEVICES" =~ "$dev" ]] || [[ "$dev" =~ loop|ram ]]; then
        return 0  # Critical
    else
        return 1  # Non-critical
    fi
}

# Disable power saving on non-critical drives
for drive in /sys/block/*; do
    dev="/dev/$(basename "$drive")"
    if is_critical_device "$dev"; then
        echo "⏩ Skipping critical device: $dev"
        continue
    fi
    echo "on" | sudo tee "/sys/block/$(basename "$drive")/device/power/control" > /dev/null
    echo "$dev: ⚡ Power Saving Disabled"
done

echo "❌ Power-saving mode disabled for all non-critical drives."