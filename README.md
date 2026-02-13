# OpenSSL RPM Builder for CentOS/RHEL - Build latest OpenSSL binary

![GitHub last commit](https://img.shields.io/github/last-commit/philyuchkoff/openssl-RPM-Builder?style=for-the-badge)
![GitHub All Releases](https://img.shields.io/github/downloads/philyuchkoff/openssl-RPM-Builder/total?style=for-the-badge)

## [OpenSSL official site](https://www.openssl.org/)

## Quick Start (Recommended)

Use the new unified build script that supports all OpenSSL versions:

```bash
# Install development tools
sudo yum -y groupinstall 'Development Tools'  # or dnf on newer systems

# Clone the repository
git clone https://github.com/philyuchkoff/openssl-RPM-Builder
cd openssl-RPM-Builder

# Build OpenSSL (uses latest stable version by default)
sudo ./build-openssl.sh

# Or specify a version
sudo ./build-openssl.sh 3.6.1
sudo ./build-openssl.sh 1.1.1w
```

The built RPMs will be located in:
```
/root/rpmbuild/RPMS/x86_64/
```

### Advanced Usage

```bash
# List available OpenSSL versions
./build-openssl.sh --list

# Use custom installation directory
sudo OPENSSL_DIR=/opt/openssl ./build-openssl.sh 3.6.1

# View help
./build-openssl.sh --help
```

## Remove old versions

Before installing the new OpenSSL RPMs, remove existing packages:

```bash
# List OpenSSL packages
rpm -qa | grep openssl

# Remove existing OpenSSL (use with caution)
rpm -e --justdb --nodeps <package-name>
```

## Legacy Scripts (Deprecated)

The old version-specific scripts are still available for backward compatibility:

```bash
# OpenSSL 3.6.1 (deprecated - use unified script instead)
sudo ./install-openssl_3.sh

# OpenSSL 1.1.1w (deprecated - use unified script instead)
sudo ./install-openssl_1.1.1.sh
```

> **Note**: These scripts are deprecated and will be removed in a future version. Please migrate to the unified `build-openssl.sh` script.

## Version-Specific Information

### OpenSSL 3.6.1
- [Release Page](https://github.com/openssl/openssl/releases/tag/openssl-3.6.1)
- Current stable release
- Recommended for new installations

### OpenSSL 1.1.1w
- [OpenSSL 1.1.1 End of Life](https://www.openssl.org/blog/blog/2023/03/28/1.1.1-EOL/)
- Consider upgrading to OpenSSL 3.x if possible
- Use only for compatibility with existing applications

## Installation of Built RPMs

After the build completes, install the generated RPM packages:

```bash
# Find the built RPMs
ls /root/rpmbuild/RPMS/x86_64/openssl-*.rpm

# Install the main package
sudo rpm -ivvh /root/rpmbuild/RPMS/x86_64/openssl-<version>-1.el<release>.x86_64.rpm --nodeps

# For development, also install the devel package
sudo rpm -ivvh /root/rpmbuild/RPMS/x86_64/openssl-devel-<version>-1.el<release>.x86_64.rpm --nodeps
```

## Verification

Check the installation:

```bash
# Check OpenSSL version
openssl version

# Example output:
# OpenSSL 3.6.1 7 May 2024
# or
# OpenSSL 1.1.1w  11 Sep 2023

# Verify RPM installation
rpm -qa openssl
# Example output:
# openssl-3.6.1-1.el9.x86_64
```

## Architecture

The OpenSSL RPM Builder is now modularized with the following components:

```
openssl-RPM-Builder/
├── README.md                    # This file
├── common.sh                    # Shared functions library
├── config.sh                    # Default configuration
├── build-openssl.sh             # Main unified script
├── install-openssl_1.1.1.sh     # Legacy script (deprecated)
└── install-openssl_3.sh         # Legacy script (deprecated)
```

### Benefits of the New Architecture

- **Reduced Code Duplication**: Common functionality is centralized in `common.sh`
- **Easy Version Support**: Add new OpenSSL versions by updating the configuration
- **Unified Interface**: One script supports all OpenSSL versions
- **Better Error Handling**: Consistent error reporting and cleanup
- **Flexible Configuration**: Customize paths and build options
- **Backward Compatibility**: Existing workflows continue to work

## Contributing

Feel free to submit issues and pull requests to improve the OpenSSL RPM Builder!

## For Fun

[![Star History Chart](https://api.star-history.com/svg?repos=philyuchkoff/openssl-RPM-Builder&type=date&legend=top-left)](https://www.star-history.com/#philyuchkoff/openssl-RPM-Builder&type=date&legend=top-left)