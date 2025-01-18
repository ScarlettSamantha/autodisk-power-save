#!/bin/bash

GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

# Check power state of all drives and display with emojis
for drive in /sys/block/*; do
    dev=$(basename "$drive")
    [[ "$dev" =~ loop|ram ]] && continue
    power_state=$(cat "/sys/block/$dev/device/power/control")
    if [[ "$power_state" == "auto" ]]; then
        echo -e "${GREEN}$dev: 🌚 Power Saving Enabled (auto)${NC}"
    else
        echo -e "${ORANGE}$dev: ⚡  Power Saving Disabled (on)${NC}"
    fi
done
