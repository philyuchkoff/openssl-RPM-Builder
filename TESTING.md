# Testing Guide

This document explains the testing strategy for OpenSSL RPM Builder.

## Test Suite Overview

The test suite is organized into:
- **Unit Tests**: Test individual components in isolation
- **Integration Tests**: Test the complete workflow
- **Fixtures**: Mock objects and test data

## Core Test Areas

### 1. SPEC File Generation (`test_spec_generation.bats`)
Validates that generated RPM SPEC files:
- Have correct metadata (name, version, license)
- Include proper dependencies
- Define correct file paths
- Set up build instructions correctly

### 2. Checksum Verification (`test_checksum_verification.bats`)
Ensures file integrity checking:
- Accepts valid checksums
- Rejects invalid checksums
- Handles missing files gracefully
- Detects corrupted files

### 3. Dependency Installation (`test_dependency_installation.bats`)
Tests package manager integration:
- Installs required packages
- Handles version-specific dependencies
- Properly removes conflicting packages
- Gracefully handles missing packages

### 4. Symlink Creation (`test_symlink_creation.bats`)
Verifies system integration:
- Creates correct symbolic links
- Maintains proper permissions
- Points to correct targets
- Replaces old symlinks on reinstallation

### 5. Full Build (`test_full_build.bats`)
Integration tests covering:
- Complete build workflow
- Error handling paths
- Multiple version support

## Running Tests

### Quick Start
```bash
# Install dependencies
make test-setup

# Run all tests
make test

# Run with verbose output
make test-verbose
```

### Advanced Options
```bash
# Using the test runner directly
./tests/run_tests.sh --help

# Specific test types
./tests/run_tests.sh --unit --verbose
./tests/run_tests.sh --integration --ci
```

## Continuous Integration

The project includes GitHub Actions workflow that:
- Tests on multiple distributions (Ubuntu, CentOS, Alpine)
- Runs complete test suite
- Provides failure diagnostics

## Writing New Tests

### Best Practices

1. **Isolation**: Each test should be independent
2. **Cleanup**: Use teardown to clean up temporary files
3. **Mock External Services**: Test without network dependencies
4. **Test Failures**: Verify error handling works correctly

### Test Structure

```bats
#!/usr/bin/env bats

load ../test_helpers  # Load helper functions

setup() {
    # Runs before each test
    export TEST_TEMP_DIR=$(mktemp -d)
}

teardown() {
    # Runs after each test
    rm -rf ${TEST_TEMP_DIR}
}

@test "describe what the test does" {
    # Test implementation
    [ "$result" = "expected" ]
}

@test "test error condition" {
    run command_that_should_fail
    [ "$status" -ne 0 ]
    grep -q "error message" <<< "$output"
}
```

## Coverage Reports

To see which parts of the code are tested:

```bash
# Install bats-coverage
npm install -g bats-coverage

# Run with coverage
bats-coverage tests/unit/
```

## Debugging Failed Tests

1. **Verbose Mode**: `bats -v test_file.bats`
2. **Trace Mode**: `bats --trace test_file.bats`
3. **Interactive Debug**: Add `echo` statements in tests
4. **Check Environment**: Ensure all dependencies are installed

## Performance Testing

For larger scale testing:

```bash
# Run tests multiple times
for i in {1..100}; do
    make test || ./notify-failure.sh
done

# Measure test runtime
time make test
```