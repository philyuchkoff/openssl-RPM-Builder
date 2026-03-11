#!/usr/bin/env bats

# Integration tests for full build process
# These tests simulate the complete build workflow

setup() {
    export TEST_TEMP_DIR=$(mktemp -d)
    export BUILD_ROOT="${TEST_TEMP_DIR}/rpmbuild"
    export ORACLE_FILE="${BUILD_ROOT}/build.log"

    # Mock rpm build environment
    mkdir -p "${BUILD_ROOT}"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

    # Prepare test OpenSSL archive
    OPENSSL_VERSION="3.6.1"
    echo "test openssl content" > "${BUILD_ROOT}/SOURCES/openssl-${OPENSSL_VERSION}.tar.gz"
}

teardown() {
    rm -rf ${TEST_TEMP_DIR}
}

@test "complete build workflow for OpenSSL 3.6.1" {
    # Mock script execution
    load ../test_helpers

    # Step 1: Create SPEC file
    run create_spec_file "${OPENSSL_VERSION}"

    [ "$status" -eq 0 ]
    [ -f "${BUILD_ROOT}/SPECS/openssl.spec" ]

    # Step 2: Mock download and verification
    cd "${BUILD_ROOT}/SOURCES"
    echo "a36a8b95d05ada3381bb4c7253a57d1b6c924d23c48d4a4702a0b52783324f0f openssl-${OPENSSL_VERSION}.tar.gz" > "openssl-${OPENSSL_VERSION}.tar.gz.sha256"

    # Step 3: Verify checksum
    run sha256sum -c "openssl-${OPENSSL_VERSION}.tar.gz.sha256"

    [ "$status" -ne 0 ]  # Should fail with our mock file

    # Create real checksum for our mock file
    sha256sum "openssl-${OPENSSL_VERSION}.tar.gz" > "openssl-${OPENSSL_VERSION}.tar.gz.sha256"

    run sha256sum -c "openssl-${OPENSSL_VERSION}.tar.gz.sha256"

    [ "$status" -eq 0 ]
    grep -q "OK" <<< "$output"

    # Step 4: Mock rpmbuild
    echo "Mock RPM build successful"
    touch "${BUILD_ROOT}/RPMS/x86_64/openssl-${OPENSSL_VERSION}-1.el9.x86_64.rpm"

    # Verify RPM was created
    [ -f "${BUILD_ROOT}/RPMS/x86_64/openssl-${OPENSSL_VERSION}-1.el9.x86_64.rpm" ]

    # List built packages
    find "${BUILD_ROOT}/RPMS" -name "*.rpm"
}

@test "build failure path with invalid checksum" {
    # Create invalid checksum file
    echo "0000000000000000000000000000000000000000000000000000000000000000 openssl-${OPENSSL_VERSION}.tar.gz" > "${BUILD_ROOT}/SOURCES/openssl-${OPENSSL_VERSION}.tar.gz.sha256"

    # Attempt verification
    cd "${BUILD_ROOT}/SOURCES"
    run sha256sum -c "openssl-${OPENSSL_VERSION}.tar.gz.sha256"

    [ "$status" -ne 0 ]
    grep -q "FAILED" <<< "$output"
}

@test "build failure with missing dependencies" {
    # Mock dependency check failure
    check_dependency() {
        local pkg=$1
        if [ "$pkg" = "gcc" ]; then
            echo "gcc is not installed"
            return 1
        fi
        echo "$pkg is installed"
        return 0
    }

    # Simulate dependency check
    run check_dependency "gcc"

    [ "$status" -eq 1 ]
}

@test "multiple OpenSSL versions can be built separately" {
    local versions=("3.6.1" "1.1.1w")

    for version in "${versions[@]}"; do
        # Create separate build directories
        local version_build_dir="${TEST_TEMP_DIR}/${version}-build"
        mkdir -p "${version_build_dir}"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

        # Create version-specific SPEC
        BUILD_ROOT="${version_build_dir}" create_spec_file "$version"

        # Verify SPEC exists and contains correct version
        [ -f "${version_build_dir}/SPECS/openssl.spec" ]
        grep -q "Version: $version" "${version_build_dir}/SPECS/openssl.spec"

        # Create mock RPM
        touch "${version_build_dir}/RPMS/x86_64/openssl-${version}-1.el9.x86_64.rpm"
    done

    # Both versions should have their respective RPMs
    [ -f "${TEST_TEMP_DIR}/3.6.1-build/RPMS/x86_64/openssl-3.6.1-1.el9.x86_64.rpm" ]
    [ -f "${TEST_TEMP_DIR}/1.1.1w-build/RPMS/x86_64/openssl-1.1.1w-1.el9.x86_64.rpm" ]
}