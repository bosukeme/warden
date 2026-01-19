#!/bin/bash


user_audit() {
    log "Listing standard human users..."

    local online_users
    online_users=$(who | awk '{print $1}' | sort -u)

    printf "%-15s %-10s %-12s\n" "User" "UID" "Status"
    printf "%-15s %-10s %-12s\n" "----" "---" "------"

    while IFS=":" read -r user _ uid _; do
        if [[ $uid -ge 1000 && $uid -ne 65534 ]]; then
            status="not logged in"
            if echo "$online_users" | grep -qw "$user"; then
                status="logged in"
            fi
            printf "%-15s %-10s %-12s\n" "$user" "$uid" "$status"
        fi
    done < /etc/passwd

    echo 
}
