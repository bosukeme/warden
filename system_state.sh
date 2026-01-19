#!/bin/bash

get_memory() {
    log "--- Memory log ---"
    free -m | awk '
    /^Mem:/ {
        printf "Used: %s MB\nFree: %s MB\nAvailable: %s MB\n", $3, $4, $7 
    }'

    echo 
}


get_disk_usage() {
    log "--- Disk Usage Audit (Threshold: $DISK_THRESHOLD%) ---"

    df -hP | awk -v limit="$DISK_THRESHOLD" '
        NR > 1 {
            # Extract the percentage value (second to last column)
            usage_str = $(NF-1)
            
            # Convert to integer by removing the % or using numeric addition
            usage_val = usage_str
            gsub("%", "", usage_val)

            if (usage_val + 0 >= limit) {
                printf "WARNING: %-20s | Usage: %s | Mount: %s\n", $1, usage_str, $NF
            }
        }
    '
    echo -e "\n"
}

get_top_processes() {
    log "Top Processes log ..."
    ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%cpu | head -n 6

    echo 
}
