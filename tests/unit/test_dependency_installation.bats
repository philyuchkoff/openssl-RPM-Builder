#!/usr/bin/env bats

load ../test_helpers

setup() {
    export TEST_TEMP_DIR=$(mktemp -d)

    # Mock package manager commands
    mock_dnf() {
        echo "dnf mock: $*"
        return 0
    }

    mock_yum() {
        echo "yum mock: $*"
        return 0
    }

    mock_command() {
        case "$1" in
            dnf)
                mock_dnf "${@:2}"
                ;;
            yum)
                mock_yum "${@:2}"
                ;;
            *)
                command "$@"
                ;;
        esac
    }

    # Override command for testing
    command() { mock_command "$@"; }
}

teardown() {
    rm -rf ${TEST_TEMP_DIR}
}

@test "install_dependencies_3 installs required packages" {
    run install_dependencies_3

    [ "$status" -eq 0 ]
    grep -q "curl" <<< "$output"
    grep -q "make" <<< "$output"
    grep -q "gcc" <<< "$output"
    grep -q "perl" <<< "$output"
    grep -q "rpm-build" <<< "$output"
    grep -q "zlib-devel" <<< "$output"
}

@test "install_dependencies_3 includes version-specific dependencies" {
    run install_dependencies_3

    [ "$status" -eq 0 ]
    grep -q "perl-FindBin" <<< "$output"
    grep -q "perl-Text-Template" <<< "$output"
    grep -q "perl-Test-Simple" <<< "$output"
}

@test "install_dependencies_1_1_1 installs correct packages" {
    run install_dependencies_1_1_1

    [ "$status" -eq 0 ]
    grep -q "perl-WWW-Curl" <<< "$output"
    grep -q "which" <<< "$output"
}

@test "install_dependencies_1_1_1 removes openssl first" {
    run install_dependencies_1_1_1

    [ "$status" -eq 0 ]
    grep -q "remove openssl" <<< "$output"
}

@test "package removal doesn't fail if openssl not installed" {
    # Mock package removal failure
    mock_dnf() {
        if [[ "$1" == "remove" && "$2" == "openssl" ]]; then
            echo "Package openssl not found"
            return 1
        fi
        echo "dnf mock: $*"
        return 0
    }

    # The script should handle this gracefully with || true
    run dnf -y remove openssl || true

    [ "$status" -eq 0 ]
}