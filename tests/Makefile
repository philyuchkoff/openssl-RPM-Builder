.PHONY: test test-unit test-integration test-deps clean help

# Default target
test:
	@echo "Running all tests..."
	@$(MAKE) test-deps
	@$(MAKE) test-unit
	@$(MAKE) test-integration

# Run unit tests
test-unit:
	@echo "Running unit tests..."
	@cd unit && bats -t *.bats

# Run integration tests
test-integration:
	@echo "Running integration tests..."
	@cd integration && bats -t *.bats

# Install test dependencies
test-deps:
	@echo "Checking dependencies..."
	@bash test_dependencies.sh

# Clean up test artifacts
clean:
	@echo "Cleaning up..."
	@rm -rf *.tmp
	@rm -rf test-build-*

# Continuous integration format (for CI/CD)
test-ci:
	@echo "Running tests in CI mode..."
	@$(MAKE) test-deps
	@cd unit && bats --formatter tap *.bats
	@cd integration && bats --formatter tap *.bats

# Verbose output
test-verbose:
	@echo "Running tests with verbose output..."
	@$(MAKE) test-deps
	@cd unit && bats -v *.bats
	@cd integration && bats -v *.bats

# Watch mode (requires entr tool)
watch:
	@echo "Running tests in watch mode..."
	@find . -name "*.bats" | entr -r $(MAKE) test

# Help target
help:
	@echo "Available targets:"
	@echo "  test         - Run all tests"
	@echo "  test-unit    - Run unit tests only"
	@echo "  test-integration - Run integration tests only"
	@echo "  test-deps    - Check test dependencies"
	@echo "  test-ci      - Run tests in TAP format (CI)"
	@echo "  test-verbose - Run tests with verbose output"
	@echo "  watch        - Run tests on file changes (requires entr)"
	@echo "  clean        - Clean test artifacts"
	@echo "  help         - Show this help"