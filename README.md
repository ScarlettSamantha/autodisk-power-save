# Drive Power Management

This project provides scripts to enable and disable power-saving modes for non-OS drives on Linux systems, improving energy efficiency while maintaining system stability.

## Features
- **Automatic Power Saving:** Applies power-saving only to non-OS drives.
- **Safe OS Exclusion:** Dynamically detects and excludes the system drive.
- **Easy Management:** Install, uninstall, and check power-saving status with simple scripts.

## Scripts

### 1. Install Power Saving
Enables power-saving mode on all non-OS drives.
```bash
sudo bash /usr/local/bin/install_drive_power_saving.sh
```

### 2. Uninstall Power Saving
Disables power-saving mode and removes related configurations.
```bash
sudo bash /usr/local/bin/uninstall_drive_power_saving.sh
```

### 3. Check Drive Power Status
Displays the power state of all drives with emojis:
- 🌙 Power Saving Enabled  
- ⚡ Power Saving Disabled  
```bash
sudo bash /usr/local/bin/check_drive_power.sh
```

## Installation
1. Copy scripts to `/usr/local/bin/` and make them executable:
   ```bash
   sudo chmod +x /usr/local/bin/*.sh
   ```
2. Run the install script to enable power saving.

## License
This project is open-source and available for use and modification.