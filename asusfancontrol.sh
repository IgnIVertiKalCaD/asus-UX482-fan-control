#!/bin/bash

# This script adjusts the fan speed for some Asus Laptops.
# 
# Fan speed options:
#  0 - Full speed
#  2 - Auto/Silent (unknown behavior)
#  Rest - Unknown behavior (don't work?)

# Check if any parameters are passed
if [ "$#" -ne 0 ]; then
    echo -e "\033[1;31mWarning: This script does not accept parameters.\033[0m"
fi

set_fan_speed() {
    local file_path=$1
    local speed=$2
    echo "$speed" > "$file_path"
}

hwmon_number=""
for entry in /sys/devices/platform/asus-nb-wmi/hwmon/hwmon[0-9]*/; do
    hwmon_number="${entry%/}"
done

# If hwmon number is found, adjust fan speed
if [[ -n "$hwmon_number" ]]; then
    hwmon_number="${hwmon_number##*hwmon}"
    full_path_to_real_hwmon="/sys/devices/platform/asus-nb-wmi/hwmon/hwmon${hwmon_number}/pwm1_enable"

    # Change permissions and read the current fan mode
    if sudo chmod 644 "$full_path_to_real_hwmon"; then
        read -r mode_fans < "$full_path_to_real_hwmon"

        if [ "$mode_fans" -eq 2 ]; then
            set_fan_speed "$full_path_to_real_hwmon" 0
            echo "Fan speed set to full speed (0)."
        else
            set_fan_speed "$full_path_to_real_hwmon" 2
            echo "Fan speed set to silent/auto (2)."
        fi
    else
        echo -e "\033[1;31mFailed to change permissions for $full_path_to_real_hwmon.\033[0m\nThis script must be run with root permissions."
    fi
else
    echo "No hwmon device found."
fi
