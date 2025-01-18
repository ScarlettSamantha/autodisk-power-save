#!/bin/bash

echo "🔎 Script started."

# Function to check if running as root
require_root() {
    echo "🔍 Checking for root privileges..."
    if [[ "$EUID" -ne 0 ]]; then
            echo "❌ This script must be run as root."
            echo "👉 Please rerun with: sudo $0"
            exit 1
    else
        echo "✅ Running as root."
    fi
}

# Check for root privileges
require_root

# Detect root device
ROOT_DEV=$(findmnt -no SOURCE / | sed -E 's|[0-9]+$||')
echo "📦 Detected root device: $ROOT_DEV"

# Detect swap devices
SWAP_DEVICES=$(findmnt -no SOURCE -t swap | sed -E 's|[0-9]+$||')
echo "📦 Detected swap devices: $SWAP_DEVICES"

# Detect boot and EFI devices
BOOT_DEVICES=$(findmnt -no SOURCE /boot /boot/efi 2>/dev/null | sed -E 's|[0-9]+$||')
echo "📦 Detected boot/EFI devices: $BOOT_DEVICES"

# Initialize the udev rule file
RULES_FILE="/etc/udev/rules.d/99-storage-power-save.rules"
echo "" | sudo tee "$RULES_FILE" > /dev/null
echo "📝 Initialized udev rule file."

# Loop through all block devices
for drive in /sys/block/*; do
    dev="/dev/$(basename "$drive")"
    echo "🔄 Checking device: $dev"

    # Skip critical devices
    if [[ "$dev" == "$ROOT_DEV" ]] || [[ "$dev" =~ loop|ram ]] || [[ "$SWAP_DEVICES" =~ "$dev" ]] || [[ "$BOOT_DEVICES" =~ "$dev" ]]; then
        echo "⏩ Skipping critical device: $dev"
        continue
    fi

    # Apply power-saving rule
    if [[ "$dev" =~ /dev/sd.* || "$dev" =~ /dev/nvme.* ]]; then
        echo "ACTION==\"add|change\", KERNEL==\"$(basename "$dev")\", ATTR{power/control}=\"auto\"" | sudo tee -a "$RULES_FILE" > /dev/null
        echo "⚡ Applied power-saving rule to: $dev"
    fi
done

# Reload udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger
echo "🔄 Reloaded udev rules."

echo "✅ Power-saving mode enabled for non-critical, non-OS drives."
