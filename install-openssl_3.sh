#!/bin/bash
set -euo pipefail

VERSION="3.6.1"
BUILD_ROOT="/root/rpmbuild"

# Установка зависимостей
echo "Installing dependencies..."
dnf -y install \
    curl \
    make \
    gcc \
    perl \
    perl-IPC-Cmd \
    rpm-build \
    perl-FindBin \
    perl-Text-Template \
    perl-Test-Simple \
    zlib-devel \
    ca-certificates \
    perl-libwww-perl

# Удаление ненужных зависимостей
dnf -y remove openssl || true

# Подготовка окружения
mkdir -p "${BUILD_ROOT}"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

# Загрузка исходников
curl -sSfL "https://www.openssl.org/source/openssl-${VERSION}.tar.gz" \
    -o "${BUILD_ROOT}/SOURCES/openssl-${VERSION}.tar.gz"

# Создание SPEC-файла
cat << 'EOF' > "${BUILD_ROOT}/SPECS/openssl.spec"
Summary: OpenSSL %{version} for CentOS/RHEL
Name: openssl
Version: %{?version}%{!?version:3.6.1}
Release: 1%{?dist}
Obsoletes: openssl < %{version}
Conflicts: openssl < %{version}
Provides: openssl = %{version}-%{release}
URL: https://www.openssl.org/
License: Apache-2.0

%define debug_package %{nil}
Source0: openssl-%{version}.tar.gz

# Зависимости
BuildRequires: make gcc perl perl-IPC-Cmd zlib-devel perl-libwww-perl
Requires: perl-libwww-perl

%description
OpenSSL RPM for version %{version} on CentOS/RHEL

%prep
%setup -q

%build
./config --prefix=/usr/openssl --openssldir=/usr/openssl zlib
make -j$(nproc)

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

# Сборка RPM
cd "${BUILD_ROOT}/SPECS"
rpmbuild -ba --define "version ${VERSION}" openssl.spec

echo "Build completed! RPM packages:"
find "${BUILD_ROOT}/RPMS" -name "*.rpm"
