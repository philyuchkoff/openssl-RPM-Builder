#!/bin/bash

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -u, --unit         Run unit tests only"
    echo "  -i, --integration  Run integration tests only"
    echo "  -v, --verbose      Verbose output"
    echo "  -c, --ci           CI mode (TAP format)"
    echo "  -h, --help         Show this help"
}

check_deps() {
    echo "Checking dependencies..."
    if ! command -v bats >/dev/null 2>&1; then
        echo "Error: Bats not installed"
        echo "Install: https://github.com/bats-core/bats-core"
        exit 1
    fi
    echo "✓ Dependencies OK"
}

run_tests() {
    local test_type=${1:-all}
    local options=""
    local bats_cli="bats"

    case "$test_type" in
        unit)
            echo "Running unit tests..."
            cd unit
            ;;
        integration)
            echo "Running integration tests..."
            cd integration
            ;;
        all)
            echo "Running all tests..."
            options="--recursive"
            ;;
    esac

    case "$2" in
        verbose) options="-v $options" ;;
        ci)
            options="--formatter tap $options"
            bats_cli="bats"
            ;;
    esac

    if [[ "$test_type" != "all" ]]; then
        eval "$bats_cli $options *.bats"
    else
        eval "$bats_cli $options"
    fi
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--unit)
            type=unit
            shift
            ;;
        -i|--integration)
            type=integration
            shift
            ;;
        -v|--verbose)
            mode=verbose
            shift
            ;;
        -c|--ci)
            mode=ci
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Set defaults
type=${type:-all}
mode=${mode:-normal}

check_deps
run_tests "$type" "$mode"