#!/bin/bash

# Common test helper functions

verify_checksum() {
    local file=$1
    local checksum_file="${file}.sha256"

    if [ ! -f "$checksum_file" ]; then
        echo "ERROR: Checksum file not found: $checksum_file"
        exit 1
    fi

    echo "Verifying SHA256 checksum..."

    if sha256sum -c "$checksum_file" > /dev/null 2>&1; then
        echo "checksum verification successful!"
        exit 0
    else
        echo "ERROR: SHA256 checksum verification failed!"
        echo "The downloaded file may be corrupted or tampered with."
        exit 1
    fi
}

create_spec_file() {
    local version=${1:-3.6.1}
    local spec_file="${BUILD_ROOT}/SPECS/openssl.spec"

    cat << EOF > "${spec_file}"
Summary: OpenSSL ${version} for CentOS/RHEL
Name: openssl
Version: ${version}
Release: 1%{?dist}
Obsoletes: openssl < ${version}
Conflicts: openssl < ${version}
Provides: openssl = ${version}-%{release}
URL: https://www.openssl.org/
License: Apache-2.0

%define debug_package %{nil}
Source0: openssl-%{version}.tar.gz

# Зависимости
BuildRequires: make gcc perl perl-IPC-Cmd zlib-devel
Requires: perl-libwww-perl

%description
OpenSSL RPM for version ${version} on CentOS/RHEL

%prep
%setup -q

%build
./config --prefix=/usr/openssl --openssldir=/usr/openssl zlib
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
/usr/openssl

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig
EOF
}

mock_download_openssl() {
    local version=${1:-3.6.1}
    local source_dir="${2:-$BUILD_ROOT/SOURCES}"

    # Create mock file
    dd if=/dev/urandom of="${source_dir}/openssl-${version}.tar.gz" bs=1024 count=1024 2>/dev/null

    # Create checksum
    cd "${source_dir}"
    sha256sum "openssl-${version}.tar.gz" > "openssl-${version}.tar.gz.sha256"
}