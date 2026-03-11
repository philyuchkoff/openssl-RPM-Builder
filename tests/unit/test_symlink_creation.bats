#!/usr/bin/env bats

setup() {
    export TEST_TEMP_DIR=$(mktemp -d)
    export BUILD_ROOT="${TEST_TEMP_DIR}/buildroot"

    # Simulate RPM build structure
    mkdir -p "${BUILD_ROOT}/usr/openssl/bin"
    mkdir -p "${BUILD_ROOT}/usr/openssl/lib64"

    # Mock binaries and libraries
    touch "${BUILD_ROOT}/usr/openssl/bin/openssl"
    touch "${BUILD_ROOT}/usr/openssl/lib64/libssl.so.3"
    touch "${BUILD_ROOT}/usr/openssl/lib64/libcrypto.so.3"

    mkdir -p "${BUILD_ROOT}/usr/bin"
    mkdir -p "${BUILD_ROOT}/usr/lib64"
}

teardown() {
    rm -rf ${TEST_TEMP_DIR}
}

@test "symlinks are created correctly" {
    # Simulate symlink creation from spec file
    ln -sf ../openssl/bin/openssl "${BUILD_ROOT}/usr/bin/openssl"
    ln -sf ../openssl/lib64/libssl.so.3 "${BUILD_ROOT}/usr/lib64/libssl.so.3"
    ln -sf ../openssl/lib64/libcrypto.so.3 "${BUILD_ROOT}/usr/lib64/libcrypto.so.3"

    # Verify symlinks exist and point to correct targets
    [ -L "${BUILD_ROOT}/usr/bin/openssl" ]
    [ -L "${BUILD_ROOT}/usr/lib64/libssl.so.3" ]
    [ -L "${BUILD_ROOT}/usr/lib64/libcrypto.so.3" ]

    # Check symlink targets are correct
    [[ $(readlink "${BUILD_ROOT}/usr/bin/openssl") == "../openssl/bin/openssl" ]]
    [[ $(readlink "${BUILD_ROOT}/usr/lib64/libssl.so.3") == "../openssl/lib64/libssl.so.3" ]]
    [[ $(readlink "${BUILD_ROOT}/usr/lib64/libcrypto.so.3") == "../openssl/lib64/libcrypto.so.3" ]]
}

@test "symlinks are accessible from system paths" {
    # Create symlinks
    ln -sf ../openssl/bin/openssl "${BUILD_ROOT}/usr/bin/openssl"
    ln -sf ../openssl/lib64/libssl.so.3 "${BUILD_ROOT}/usr/lib64/libssl.so.3"
    ln -sf ../openssl/lib64/libcrypto.so.3 "${BUILD_ROOT}/usr/lib64/libcrypto.so.3"

    # Verify symlinks can be accessed
    [ -r "${BUILD_ROOT}/usr/bin/openssl" ]
    [ -r "${BUILD_ROOT}/usr/lib64/libssl.so.3" ]
    [ -r "${BUILD_ROOT}/usr/lib64/libcrypto.so.3" ]
}

@test "symlinks maintain correct permissions" {
    # Create symlinks with specific permissions
    ln -sf ../openssl/bin/openssl "${BUILD_ROOT}/usr/bin/openssl"
    ln -sf ../openssl/lib64/libssl.so.3 "${BUILD_ROOT}/usr/lib64/libssl.so.3"
    ln -sf ../openssl/lib64/libcrypto.so.3 "${BUILD_ROOT}/usr/lib64/libcrypto.so.3"

    # Check they are executable/readable
    [ -x "${BUILD_ROOT}/usr/bin/openssl" ]
    [ -r "${BUILD_ROOT}/usr/lib64/libssl.so.3" ]
    [ -r "${BUILD_ROOT}/usr/lib64/libcrypto.so.3" ]
}

@test "old symlinks are replaced if present" {
    # Create old symlinks
    ln -sf /old/path/openssl "${BUILD_ROOT}/usr/bin/openssl"
    ln -sf /old/path/libssl.so.2 "${BUILD_ROOT}/usr/lib64/libssl.so.3"

    # Replace with new symlinks
    ln -sf ../openssl/bin/openssl "${BUILD_ROOT}/usr/bin/openssl"
    ln -sf ../openssl/lib64/libssl.so.3 "${BUILD_ROOT}/usr/lib64/libssl.so.3"

    # Verify targets are updated
    [[ $(readlink "${BUILD_ROOT}/usr/bin/openssl") == "../openssl/bin/openssl" ]]
    [[ $(readlink "${BUILD_ROOT}/usr/lib64/libssl.so.3") == "../openssl/lib64/libssl.so.3" ]]
}