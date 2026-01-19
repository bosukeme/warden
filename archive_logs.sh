#!/bin/bash


log_cleanup() {

    log "Log Clean Up Processing ..."

    mkdir -p "$BACKUP_DIR"

    local timestamp
    timestamp=$(date '+%Y%m%d-%H%M%S')

    local archive_file="$BACKUP_DIR/archive-$timestamp.tar.gz"

    mapfile -t log_files < <(
        find "$SOURCE_DIR" -type f -name "*.log" -mtime +"$DAYS_TO_KEEP"
    )

    if (( ${#log_files[@]} == 0 )); then
        log "No log files found. Skipping archive creation."
        return 0
    fi

    tar -czf "$archive_file" -C "$SOURCE_DIR" "${log_files[@]/$SOURCE_DIR\//}"

    log "Archive created: $archive_file"
    echo
}