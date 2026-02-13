#!/bin/bash

# OpenSSL RPM Builder - Configuration File
# This file contains default configuration values for building OpenSSL RPMs

# Default OpenSSL version to build (can be overridden via command line)
DEFAULT_VERSION="3.6.1"

# Build root directory
BUILD_ROOT="/root/rpmbuild"

# OpenSSL installation directory
OPENSSL_DIR="/usr/openssl"

# System architecture
ARCH="x86_64"

# Available OpenSSL versions
OPENSSL_VERSIONS=("1.1.1w=stable" "3.6.1=stable" "3.7.0=dev" "3.6.2=stable")

# Package manager detection
PACKAGE_MANAGER=""
CONFIG_LOADED=true