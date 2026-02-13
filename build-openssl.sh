#!/bin/bash

# OpenSSL RPM Builder - Unified Build Script
# This script builds OpenSSL RPM packages for specified versions
# Usage: sudo ./build-openssl.sh [VERSION]

# Strict error handling
set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load configuration and common functions
source "${SCRIPT_DIR}/config.sh"
source "${SCRIPT_DIR}/common.sh"

# Display help
show_help() {
    cat << EOF
OpenSSL RPM Builder - Unified Build Script

USAGE:
    sudo ./build-openssl.sh [OPTIONS] [VERSION]

ARGUMENTS:
    VERSION    OpenSSL version to build (e.g., 1.1.1w, 3.6.1)
               If not provided, uses DEFAULT_VERSION=${DEFAULT_VERSION}

OPTIONS:
    -h, --help          Show this help message
    -l, --list          List available OpenSSL versions
    -c, --config FILE   Use custom configuration file

ENVIRONMENT VARIABLES:
    OPENSSL_DIR         OpenSSL installation directory (default: ${OPENSSL_DIR})
    BUILD_ROOT          RPM build root directory (default: ${BUILD_ROOT})
    ARCH                System architecture (default: ${ARCH})

EXAMPLES:
    # Build with default version (${DEFAULT_VERSION})
    sudo ./build-openssl.sh

    # Build specific version
    sudo ./build-openssl.sh 1.1.1w
    sudo ./build-openssl.sh 3.6.1

    # Custom installation directory
    sudo OPENSSL_DIR=/opt/openssl ./build-openssl.sh 3.6.1

    # List available versions
    ./build-openssl.sh --list

EOF
}

# List available OpenSSL versions
list_versions() {
    echo
    log_info "Available OpenSSL versions:"
    echo

    for version_config in "${OPENSSL_VERSIONS[@]}"; do
        version="${version_config%=*}"
        status="${version_config#*=}"
        if [[ "$status" == "stable" ]]; then
            echo -e "  ${GREEN}${version}${NC} (stable)"
        elif [[ "$status" == "dev" ]]; then
            echo -e "  ${YELLOW}${version}${NC} (development)"
        fi
    done
    echo
}

# Parse command line arguments
parse_args() {
    VERSION=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -l|--list)
                list_versions
                exit 0
                ;;
            -c|--config)
                shift
                if [[ -f "$1" ]]; then
                    source "$1"
                    log_info "Using configuration file: $1"
                else
                    log_error "Configuration file not found: $1"
                    exit 1
                fi
                ;;
            *)
                if [[ -z "$VERSION" ]]; then
                    VERSION="$1"
                else
                    log_error "Too many arguments. Use --help for usage."
                    exit 1
                fi
                ;;
        esac
        shift
    done

    # Use default version if not specified
    if [[ -z "$VERSION" ]]; then
        VERSION="$DEFAULT_VERSION"
        log_info "No version specified, using default: $VERSION"
    fi
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."

    # Check if running as root
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root (use sudo)"
        exit 1
    fi

    # Validate version format
    validate_version "$VERSION"

    # Check if version configuration exists
    version_found=0
    for version_config in "${OPENSSL_VERSIONS[@]}"; do
        if [[ "${version_config%=*}" == "$VERSION" ]]; then
            version_found=1
            break
        fi
    done

    if [[ $version_found -eq 0 ]]; then
        log_warning "Version $VERSION not in predefined configurations"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi

    log_success "Prerequisites checked"
}

# Main execution
main() {
    # Display header
    echo
    echo "============================================================"
    echo "  OpenSSL RPM Builder - Unified Build Script"
    echo "============================================================"
    echo

    # Parse command line arguments
    parse_args "$@"

    # Check prerequisites
    check_prerequisites

    # Display build configuration
    log_info "Build Configuration:"
    echo "  OpenSSL Version: $VERSION"
    echo "  Build Root: $BUILD_ROOT"
    echo "  OpenSSL Directory: $OPENSSL_DIR"
    echo "  Architecture: $ARCH"
    echo "  Package Manager: $(detect_package_manager)"
    echo

    # Execute build steps
    install_dependencies "$VERSION"
    setup_build_environment "$BUILD_ROOT"
    download_openssl "$VERSION" "$BUILD_ROOT"
    generate_spec_file "$VERSION" "$BUILD_ROOT"
    build_rpm "$VERSION" "$BUILD_ROOT"

    # Show completion message
    echo
    log_success "OpenSSL $VERSION RPM build completed successfully!"
    echo
    show_install_instructions "$VERSION" "$BUILD_ROOT"
}

# Run main function with all arguments
main "$@"