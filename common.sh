#!/bin/bash

# OpenSSL RPM Builder - Common Functions Library
# This file contains shared functions used by the OpenSSL RPM Builder

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Cleanup function
cleanup_on_exit() {
    local exit_code=$?
    if [[ ${exit_code} -ne 0 ]]; then
        log_error "Script failed with exit code ${exit_code}"
        # Cleanup temporary files if needed
    fi
}

# Error handling trap
trap cleanup_on_exit EXIT

# Detect package manager (yum vs dnf)
detect_package_manager() {
    if command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v yum &> /dev/null; then
        echo "yum"
    else
        log_error "No supported package manager found (dnf or yum)"
        exit 1
    fi
}

# Validate OpenSSL version format
validate_version() {
    local version="$1"
    if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+[a-z]?$ ]]; then
        log_error "Invalid version format: $version (expected format: X.X.X or X.X.Xz)"
        exit 1
    fi
}

# Get OpenSSL series (1.1.1 or 3)
get_openssl_series() {
    local version="$1"
    if [[ "$version" =~ ^1\.1\.1 ]]; then
        echo "1.1.1"
    elif [[ "$version" =~ ^3\. ]]; then
        echo "3"
    else
        log_error "Unsupported OpenSSL version: $version"
        exit 1
    fi
}

# Install dependencies based on OpenSSL version
install_dependencies() {
    local version="$1"
    local pkg_manager
    pkg_manager=$(detect_package_manager)

    log_info "Installing dependencies using ${pkg_manager}..."

    local packages="curl which make gcc perl rpm-build"

    if [[ "$version" =~ ^1\.1\.1 ]]; then
        packages="$packages perl-WWW-Curl"
    elif [[ "$version" =~ ^3\. ]]; then
        packages="$packages perl-IPC-Cmd perl-FindBin perl-Text-Template \
                        perl-Test-Simple zlib-devel ca-certificates perl-libwww-perl"
    fi

    ${pkg_manager} -y install ${packages}

    # Remove existing openssl (non-fatal if it fails)
    ${pkg_manager} -y remove openssl || true
}

# Setup build environment
setup_build_environment() {
    local build_root="$1"
    log_info "Setting up build environment..."

    mkdir -p "${build_root}"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

    log_success "Build environment created at ${build_root}"
}

# Download OpenSSL source
download_openssl() {
    local version="$1"
    local build_root="$2"
    local filename="openssl-${version}.tar.gz"
    local url="https://www.openssl.org/source/${filename}"

    log_info "Downloading OpenSSL ${version}..."

    if curl -sSfL "${url}" -o "${build_root}/SOURCES/${filename}"; then
        log_success "Downloaded ${filename}"
    else
        log_error "Failed to download ${filename} from ${url}"
        exit 1
    fi
}

# Generate SPEC file based on OpenSSL version
generate_spec_file() {
    local version="$1"
    local build_root="$2"
    local series
    series=$(get_openssl_series "$version")

    local spec_file="${build_root}/SPECS/openssl.spec"

    log_info "Generating SPEC file for OpenSSL ${version}..."

    if [[ "$series" == "1.1.1" ]]; then
        generate_spec_1_1_1 "$version" "$spec_file"
    elif [[ "$series" == "3" ]]; then
        generate_spec_3 "$version" "$spec_file"
    fi

    log_success "SPEC file generated at ${spec_file}"
}

# Generate SPEC file for OpenSSL 1.1.1
generate_spec_1_1_1() {
    local version="$1"
    local spec_file="$2"

    cat > "$spec_file" << EOF
Summary: OpenSSL ${version} for CentOS/RHEL
Name: openssl
Version: %{?version}%{!?version:${version}}
Version: ${version}
Release: 1%{?dist}
Obsoletes: %{name} <= %{version}
Provides: %{name} = %{version}
URL: https://www.openssl.org/
License: GPLv2+

Source: https://www.openssl.org/source/%{name}-%{version}.tar.gz

BuildRequires: make gcc perl perl-WWW-Curl
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
%global openssldir ${OPENSSL_DIR:-/usr/openssl}

%description
OpenSSL RPM for version ${version} on CentOS/RHEL

%package devel
Summary: Development files for programs which will use the openssl library
Group: Development/Libraries
Requires: %{name} = %{version}-%{release}

%description devel
OpenSSL RPM for version ${version} on CentOS/RHEL (development package)

%prep
%setup -q

%build
./config --prefix=%{openssldir} --openssldir=%{openssldir}
make

%install
[ "%{buildroot}" != "/" ] && %{__rm} -rf %{buildroot}
%make_install

mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_libdir}
ln -sf %{openssldir}/lib/libssl.so.1.1 %{buildroot}%{_libdir}
ln -sf %{openssldir}/lib/libcrypto.so.1.1 %{buildroot}%{_libdir}
ln -sf %{openssldir}/bin/openssl %{buildroot}%{_bindir}

%clean
[ "%{buildroot}" != "/" ] && %{__rm} -rf %{buildroot}

%files
%{openssldir}
%defattr(-,root,root)
/usr/bin/openssl
/usr/lib64/libcrypto.so.1.1
/usr/lib64/libssl.so.1.1

%files devel
%{openssldir}/include/*
%defattr(-,root,root)

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig
EOF
}

# Generate SPEC file for OpenSSL 3.x
generate_spec_3() {
    local version="$1"
    local spec_file="$2"

    cat > "$spec_file" << EOF
Summary: OpenSSL ${version} for CentOS/RHEL
Name: openssl
Version: %{?version}%{!?version:${version}}
Release: 1%{?dist}
Obsoletes: openssl < %{version}
Conflicts: openssl < %{version}
Provides: openssl = %{version}-%{release}
URL: https://www.openssl.org/
License: Apache-2.0

%define debug_package %{nil}
Source0: openssl-%{version}.tar.gz

BuildRequires: make gcc perl perl-IPC-Cmd zlib-devel perl-libwww-perl
Requires: perl-libwww-perl

%description
OpenSSL RPM for version ${version} on CentOS/RHEL

%prep
%setup -q

%build
./config --prefix=${OPENSSL_DIR:-/usr/openssl} --openssldir=${OPENSSL_DIR:-/usr/openssl} zlib
make -j\$(nproc)

%install
rm -rf %{buildroot}
%make_install

install -d %{buildroot}/usr/bin
install -d %{buildroot}/usr/lib64
ln -sf ../openssl/bin/openssl %{buildroot}/usr/bin/openssl
ln -sf ../openssl/lib64/libssl.so.3 %{buildroot}/usr/lib64/libssl.so.3
ln -sf ../openssl/lib64/libcrypto.so.3 %{buildroot}/usr/lib64/libcrypto.so.3

%files
/usr/bin/openssl
/usr/lib64/libssl.so.3
/usr/lib64/libcrypto.so.3
${OPENSSL_DIR:-/usr/openssl}

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig
EOF
}

# Build RPM package
build_rpm() {
    local version="$1"
    local build_root="$2"

    log_info "Building RPM packages..."

    cd "${build_root}/SPECS"

    if rpmbuild -ba --define "version ${version}" openssl.spec; then
        log_success "RPM build completed successfully!"
    else
        log_error "RPM build failed!"
        exit 1
    fi

    echo
    log_info "Generated RPM packages:"
    find "${build_root}/RPMS" -name "*.rpm" -exec basename {} \;
}

# Display installation instructions
show_install_instructions() {
    local version="$1"
    local build_root="$2"
    local arch="${ARCH:-x86_64}"

    echo
    log_info "To install the built RPMs, run:"
    echo "  rpm -ivvh ${build_root}/RPMS/${arch}/openssl-${version}-1*.${arch}..rpm --nodeps"
    echo
    log_info "To verify installation:"
    echo "  rpm -qa openssl"
    echo "  openssl version"
}