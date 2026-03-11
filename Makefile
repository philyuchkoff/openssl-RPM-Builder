.PHONY: test install help clean all

# Default target
all:
	@echo "OpenSSL RPM Builder"
	@echo "Run 'make help' for available commands"

# Install OpenSSL 3.x
install:
	@echo "Installing OpenSSL 3.x..."
	@if [ -f install-openssl_3.sh ]; then
		sudo ./install-openssl_3.sh
	else
		echo "Error: install-openssl_3.sh not found"
		exit 1
	fi

# Install OpenSSL 1.1.1
install-1.1.1:
	@echo "Installing OpenSSL 1.1.1..."
	@if [ -f install-openssl_1.1.1.sh ]; then
		sudo ./install-openssl_1.1.1.sh
	else
		echo "Error: install-openssl_1.1.1.sh not found"
		exit 1
	fi

# Run tests
test:
	@echo "Running test suite..."
	@cd tests && $(MAKE) test

# Install test dependencies
test-setup:
	@cd tests && $(MAKE) test-deps

# Build both versions (for testing)
build-test:
	@echo "Building both OpenSSL versions for testing..."
	@mkdir -p build-test
	@VERSION=3.6.1 BUILD_ROOT=build-test/rpmbuild-3.6.1 ./install-openssl_3.sh
	@VERSION=1.1.1w BUILD_ROOT=build-test/rpmbuild-1.1.1 ./install-openssl_1.1.1.sh

# Clean
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf /root/rpmbuild
	@rm -rf build-test
	@rm -f *.rpm

# Clean test artifacts
clean-tests:
	@cd tests && $(MAKE) clean

# Help
help:
	@echo "Available targets:"
	@echo "  install       - Install OpenSSL 3.x"
	@echo "  install-1.1.1- Install OpenSSL 1.1.1"
	@echo "  test         - Run all tests"
	@echo "  test-setup   - Install test dependencies"
	@echo "  build-test   - Build both versions for testing"
	@echo "  clean        - Remove build artifacts"
	@echo "  clean-tests  - Remove test artifacts"
	@echo "  help         - Show this help"
	@echo ""
	@echo "For more test options, use: cd tests && make help"