#!/usr/bin/env bats

setup() {
    export TEST_TEMP_DIR=$(mktemp -d)
    export BUILD_ROOT="${TEST_TEMP_DIR}/rpmbuild"
    mkdir -p "${BUILD_ROOT}"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

    # Load the script under test
    source ../install-openssl_3.sh
}

teardown() {
    rm -rf ${TEST_TEMP_DIR}
}

@test "SPEC file is created correctly for OpenSSL 3.6.1" {
    run create_spec_file "3.6.1"

    [ "$status" -eq 0 ]
    [ -f "${BUILD_ROOT}/SPECS/openssl.spec" ]

    # Check key elements in SPEC file
    grep -q "Summary: OpenSSL 3.6.1 for CentOS/RHEL" "${BUILD_ROOT}/SPECS/openssl.spec"
    grep -q "Name: openssl" "${BUILD_ROOT}/SPECS/openssl.spec"
    grep -q "Version: ${VERSION:-3.6.1}" "${BUILD_ROOT}/SPECS/openssl.spec"
    grep -q "License: Apache-2.0" "${BUILD_ROOT}/SPECS/openssl.spec"
    grep -q '%setup -q' "${BUILD_ROOT}/SPECS/openssl.spec"
    grep -q './config --prefix=/usr/openssl' "${BUILD_ROOT}/SPECS/openssl.spec"
    grep -q '%post -p /sbin/ldconfig' "${BUILD_ROOT}/SPECS/openssl.spec"
}

@test "SPEC file has correct dependencies defined" {
    run create_spec_file "3.6.1"

    [ "$status" -eq 0 ]

    # Check BuildRequires
    grep -q "BuildRequires: make gcc perl perl-IPC-Cmd zlib-devel" "${BUILD_ROOT}/SPECS/openssl.spec"

    # Check runtime dependencies
    grep -q "Requires: perl-libwww-perl" "${BUILD_ROOT}/SPECS/openssl.spec"
}

@test "SPEC file defines correct file paths" {
    run create_spec_file "3.6.1"

    [ "$status" -eq 0 ]

    # Check %files section
    grep -q "/usr/bin/openssl" "${BUILD_ROOT}/SPECS/openssl.spec"
    grep -q "/usr/lib64/libssl.so.3" "${BUILD_ROOT}/SPECS/openssl.spec"
    grep -q "/usr/lib64/libcrypto.so.3" "${BUILD_ROOT}/SPECS/openssl.spec"
    grep -q "/usr/openssl" "${BUILD_ROOT}/SPECS/openssl.spec"
}

@test "SPEC file version is customizable" {
    run create_spec_file "3.7.0"

    [ "$status" -eq 0 ]

    grep -q "Summary: OpenSSL 3.7.0 for CentOS/RHEL" "${BUILD_ROOT}/SPECS/openssl.spec"
    grep -q "Version: 3.7.0" "${BUILD_ROOT}/SPECS/openssl.spec"
}

@test "SPEC file has correct conflict definitions" {
    run create_spec_file "3.6.1"

    [ "$status" -eq 0 ]

    grep -q "Obsoletes: openssl < 3.6.1" "${BUILD_ROOT}/SPECS/openssl.spec"
    grep -q "Conflicts: openssl < 3.6.1" "${BUILD_ROOT}/SPECS/openssl.spec"
    grep -q "Provides: openssl = 3.6.1" "${BUILD_ROOT}/SPECS/openssl.spec"
}