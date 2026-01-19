#!/bin/bash

# --- Test Setup ---
TEST_DIR="./test_env"
TEST_LOGS="$TEST_DIR/logs"
TEST_ARCHIVE="$TEST_DIR/archive"
CONF_FILE="./warden.conf"

log() {
    echo -e "${GREEN}[$(date  '+%Y-%m-%d %H:%M:%S')] $* ${NC}"
}


setup() {
    echo "Setting up test environment..."
    mkdir -p "$TEST_LOGS"
    mkdir -p "$TEST_ARCHIVE"
    # Create a dummy log file older than 7 days
    touch -d "10 days ago" "$TEST_LOGS/old_test.log"
    # Create a fresh log file
    touch "$TEST_LOGS/new_test.log"
}

cleanup() {
    echo "Cleaning up test environment..."
    rm -rf "$TEST_DIR"
}

# --- Test Cases ---

test_log_cleanup() {
    echo "Running Test: log_cleanup..."
    
    # Source the script logic
    source ./archive_logs.sh
    
    # Override variables for testing
    SOURCE_DIR="$TEST_LOGS"
    BACKUP_DIR="$TEST_ARCHIVE"
    DAYS_TO_KEEP=7
    
    log_cleanup > /dev/null
    
    # Check if the old file was moved/archived
    if [ -f "$TEST_ARCHIVE"/*.tar.gz ]; then
        echo -e "\e[32m[PASS]\e[0m Archive created successfully."
    else
        echo -e "\e[31m[FAIL]\e[0m Archive not found."
        exit 1
    fi
}

test_config_loading() {
    echo "Running Test: Config exists..."
    if [ -f "$CONF_FILE" ]; then
        echo -e "\e[32m[PASS]\e[0m Config file found."
    else
        echo -e "\e[31m[FAIL]\e[0m Config file missing."
        exit 1
    fi
}

# --- Execution ---
setup
test_config_loading
test_log_cleanup
cleanup

echo -e "\n\e[32mAll tests passed!\e[0m"