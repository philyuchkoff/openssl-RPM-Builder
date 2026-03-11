#!/usr/bin/env bats

load ../test_helpers

setup() {
    export TEST_TEMP_DIR=$(mktemp -d)
    cd "${TEST_TEMP_DIR}"
}

teardown() {
    rm -rf ${TEST_TEMP_DIR}
}

@test "verify_checksum succeeds with correct checksum" {
    # Create test file and checksum
    echo "test content" > test.txt
    echo "a1fff0ffefb9eace7230c24e50731f0a91c62f9cefdfe77121c2f607125dffae test.txt" > test.txt.sha256

    run verify_checksum "test.txt"

    [ "$status" -eq 0 ]
    grep -q "checksum verification successful!" <<< "$output"
}

@test "verify_checksum fails with incorrect checksum" {
    # Create test file with wrong checksum
    echo "test content" > test.txt
    echo "0000000000000000000000000000000000000000000000000000000000000000 test.txt" > test.txt.sha256

    run verify_checksum "test.txt"

    [ "$status" -eq 1 ]
    grep -q "SHA256 checksum verification failed!" <<< "$output"
}

@test "verify_checksum fails when checksum file doesn't exist" {
    run verify_checksum "file_without_checksum.txt"

    [ "$status" -eq 1 ]
}

@test "verify_checksum detects missing file" {
    echo "0000000000000000000000000000000000000000000000000000000000000000 missing.txt" > missing.txt.sha256

    run verify_checksum "missing.txt"

    [ "$status" -eq 1 ]
}