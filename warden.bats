#!/usr/bin/env bats

# This runs before every test
setup() {
    # Create a temporary environment
    TEST_TEMP_DIR="$(mktemp -d)"
    mkdir -p "$TEST_TEMP_DIR/logs"
    mkdir -p "$TEST_TEMP_DIR/archive"
    
    # Define variables for the scripts to use
    export SOURCE_DIR="$TEST_TEMP_DIR/logs"
    export BACKUP_DIR="$TEST_TEMP_DIR/archive"
    export DAYS_TO_KEEP=7
    
    # Source the script files
    # Note: We use 'load' in bats instead of 'source' for better error reporting
    source "./archive_logs.sh"
    source "./system_state.sh"

    log() {
        echo "$1"
    }
    export -f log
}

# This runs after every test
teardown() {
    rm -rf "$TEST_TEMP_DIR"
}

@test "log_cleanup skips when no log files exist" {
    rm -rf "$SOURCE_DIR"/*
    run log_cleanup

    echo "Output was: $output"
    echo "Status was: $status"

    [ "$status" -eq 0 ]
    [[ "$output" =~ "No log files found" ]]
}

@test "log_cleanup archives files older than 7 days" {
    # Create one old file and one new file
    touch -d "10 days ago" "$SOURCE_DIR/old.log"
    touch "$SOURCE_DIR/new.log"

    run log_cleanup
    
    [ "$status" -eq 0 ]
    # Check that an archive was actually created
    [ "$(ls -A $BACKUP_DIR/*.tar.gz | wc -l)" -eq 1 ]
}

@test "get_disk_usage handles threshold correctly" {
    # We MOCK the 'df' command here so the test isn't dependent on your actual PC
    df() {
        echo "Filesystem Size Used Avail Use% Mounted on"
        echo "/dev/sda1   100G  90G   10G  90% /"
    }
    export -f df # Export the mock function so awk can see it

    # We set threshold to 80, so 90% should trigger a WARNING
    export DISK_THRESHOLD=80
    
    run get_disk_usage
    [[ "$output" == *"WARNING"* ]]
}

@test "get_disk_usage ignores disks below threshold" {
    df() {
        echo "Filesystem Size Used Avail Use% Mounted on"
        echo "/dev/sda1   100G  10G   90G  10% /"
    }
    export -f df
    export DISK_THRESHOLD=80
    
    run get_disk_usage
    [[ "$output" != *"WARNING"* ]]
}