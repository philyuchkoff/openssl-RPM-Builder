#!/bin/bash
# Check if required dependencies are installed

check_command() {
    local cmd=$1
    local pkg=${2:-$1}

    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "✗ Missing required command: $cmd (package: $pkg)"
        return 1
    else
        echo "✓ Found: $cmd"
        return 0
    fi
}

echo "Checking test dependencies..."
echo

# Required commands
MISSING=0

check_command "bats" "bats-core" || MISSING=1
check_command "curl" "curl" || MISSING=1
check_command "sha256sum" "coreutils" || MISSING=1
check_command "rpmbuild" "rpm-build" || MISSING=1
check_command "tar" "tar" || MISSING=1
check_command "gcc" "gcc" || MISSING=1
check_command "make" "make" || MISSING=1
check_command "perl" "perl" || MISSING=1

echo

if [ $MISSING -eq 0 ]; then
    echo "All dependencies satisfied!"
    exit 0
else
    echo "Please install missing dependencies before running tests."
    exit 1
fi