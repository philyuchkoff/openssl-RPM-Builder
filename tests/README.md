# Test Suite for OpenSSL RPM Builder

This directory contains unit and integration tests for the OpenSSL RPM builder scripts.

## Prerequisites

Install Bats (Bash Automated Testing System):

```bash
# On macOS
brew install bats-core

# On Linux
sudo apt-get install bats-core  # Debian/Ubuntu
sudo yum install bats          # CentOS/RHEL

# Or from source
git clone https://github.com/bats-core/bats-core
cd bats-core
sudo ./install.sh /usr/local
```

## Running Tests

### All Tests
```bash
make test
```

### Unit Tests Only
```bash
make test-unit
```

### Integration Tests Only
```bash
make test-integration
```

### Verbose Output
```bash
make test-verbose
```

### CI Format (TAP)
```bash
make test-ci
```

## Test Structure

```
tests/
├── unit/                   # Unit tests
│   ├── test_spec_generation.bats
│   ├── test_checksum_verification.bats
│   ├── test_dependency_installation.bats
│   └── test_symlink_creation.bats
├── integration/            # Integration tests
│   └── test_full_build.bats
├── fixtures/              # Test fixtures
│   └── mock_openssl.sh
├── test_helpers.bash       # Common test functions
├── test_dependencies.sh    # Dependency checker
├── Makefile               # Test runner
└── README.md             # This file
```

## Test Coverage

- **Unit Tests**:
  - SPEC file generation
  - Checksum verification
  - Dependency installation
  - Symlink creation

- **Integration Tests**:
  - Complete build workflow
  - Error handling
  - Multiple version support

## Writing New Tests

1. Create a new `.bats` file in the appropriate directory
2. Use the `@test` decorator for each test case
3. Follow Bats syntax and best practices
4. Add helper functions to `test_helpers.bash` if needed

Example:
```bash
#!/usr/bin/env bats

load ../test_helpers

@test "my test case" {
    # Setup
    local result=$(my_function)

    # Assertions
    [ "$result" = "expected" ]
}
```

## Debugging Tests

Set verbose mode for detailed output:
```bash
bats -v test_file.bats
```

Or use the trace option:
```bash
bats --trace test_file.bats
```

## Test Dependencies

The tests require:
- bats-core
- make
- sha256sum
- curl
- rpmbuild
- gcc
- perl

Run `make test-deps` to check for missing dependencies.