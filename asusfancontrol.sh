#!/bin/bash
# my English is very bad, sorry me
#Asus zenbook duo UX482 bios 318

#  0 - full speed
#  2 - auto / silent. I dont know
#  1 - dont working. Why? I dont know XD

set_fan_speed() {
    local speed=$2
    echo "$speed" > "$1"
}

hwmon_number=""
for entry in /sys/devices/platform/asus-nb-wmi/hwmon/hwmon[0-9]*/; do
    hwmon_number="${entry%/}"
done

if [[ -n "$hwmon_number" ]]; then
    hwmon_number="${hwmon_number##*hwmon}"
    
    full_path_to_real_hwmon="/sys/devices/platform/asus-nb-wmi/hwmon/hwmon${hwmon_number}/pwm1_enable"
    sudo chmod -R 777 $full_path_to_real_hwmon
    
    read -r mode_fans < $full_path_to_real_hwmon

    if [ "$mode_fans" -eq 2 ]; then
        set_fan_speed "$full_path_to_real_hwmon" 0
    else
        set_fan_speed "$full_path_to_real_hwmon" 2
    fi

else
    echo "Nothing found."
fi
