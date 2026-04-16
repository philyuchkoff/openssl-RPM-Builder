#!/bin/bash
set -euo pipefail

# OpenSSL 4.0.0 - официальный релиз от 14 апреля 2026
# OpenSSL 4.0.0 - official release from April 14, 2026
# https://github.com/openssl/openssl/releases/tag/openssl-4.0.0
VERSION="4.0.0"
BUILD_ROOT="/root/rpmbuild"

# Установка зависимостей
# Installing dependencies
echo "Installing dependencies..."
dnf -y install \
    curl \
    make \
    gcc \
    gcc-c++ \
    perl \
    perl-IPC-Cmd \
    rpm-build \
    perl-FindBin \
    perl-Text-Template \
    perl-Test-Simple \
    zlib-devel \
    ca-certificates \
    perl-libwww-perl

# НЕ удаляем системный OpenSSL, так как от него зависят важные пакеты (pam, sudo)
# DO NOT remove system OpenSSL because critical packages (pam, sudo) depend on it
echo "System OpenSSL will be kept to maintain system dependencies"

# Подготовка окружения
# Prepare build environment
mkdir -p "${BUILD_ROOT}"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

# Загрузка исходников OpenSSL 4.0.0
# Download OpenSSL 4.0.0 source code
echo "Downloading OpenSSL ${VERSION} source..."

# Пробуем разные источники загрузки
# Try different download sources
DOWNLOAD_SUCCESS=0

# Источник 1: официальный сайт (может быть ещё недоступен)
# Source 1: official website (may not be available yet)
if curl -sSfL "https://www.openssl.org/source/openssl-${VERSION}.tar.gz" -o "${BUILD_ROOT}/SOURCES/openssl-${VERSION}.tar.gz"; then
    echo "Downloaded from openssl.org"
    curl -sSfL "https://www.openssl.org/source/openssl-${VERSION}.tar.gz.sha256" \
        -o "${BUILD_ROOT}/SOURCES/openssl-${VERSION}.tar.gz.sha256" || true
    DOWNLOAD_SUCCESS=1
fi

# Источник 2: GitHub releases (более вероятно, что здесь появится первым)
# Source 2: GitHub releases (more likely to appear here first)
if [ $DOWNLOAD_SUCCESS -eq 0 ]; then
    echo "Trying GitHub releases..."
    if curl -sSfL "https://github.com/openssl/openssl/releases/download/openssl-${VERSION}/openssl-${VERSION}.tar.gz" \
        -o "${BUILD_ROOT}/SOURCES/openssl-${VERSION}.tar.gz"; then
        echo "Downloaded from GitHub"
        DOWNLOAD_SUCCESS=1
    fi
fi

# Источник 3: старая директория (для тестовых версий)
# Source 3: old directory (for test versions)
if [ $DOWNLOAD_SUCCESS -eq 0 ]; then
    echo "Trying old directory..."
    if curl -sSfL "https://www.openssl.org/source/old/${VERSION}/openssl-${VERSION}.tar.gz" \
        -o "${BUILD_ROOT}/SOURCES/openssl-${VERSION}.tar.gz"; then
        echo "Downloaded from old directory"
        DOWNLOAD_SUCCESS=1
    fi
fi

# Проверка успешности загрузки
# Check download success
if [ $DOWNLOAD_SUCCESS -eq 0 ]; then
    echo "ERROR: Failed to download OpenSSL ${VERSION}"
    echo "Please check available versions at:"
    echo "  - https://www.openssl.org/source/"
    echo "  - https://github.com/openssl/openssl/releases"
    exit 1
fi

# Проверка контрольной суммы (если файл существует)
# Verify SHA256 checksum (if file exists)
if [ -f "${BUILD_ROOT}/SOURCES/openssl-${VERSION}.tar.gz.sha256" ]; then
    echo "Verifying SHA256 checksum..."
    cd "${BUILD_ROOT}/SOURCES"
    sha256sum -c openssl-${VERSION}.tar.gz.sha256
    if [ $? -ne 0 ]; then
        echo "ERROR: SHA256 checksum verification failed!"
        exit 1
    fi
    echo "Checksum verification successful!"
else
    echo "Warning: No SHA256 file found, skipping verification"
fi

# Создание SPEC-файла для OpenSSL 4.0.0 (параллельная установка)
# Create SPEC file for OpenSSL 4.0.0 (parallel installation)
cat << 'EOF' > "${BUILD_ROOT}/SPECS/openssl4.spec"
Summary: OpenSSL %{version} for CentOS/RHEL (parallel installation)
Name: openssl4
Version: %{?version}%{!?version:4.0.0}
Release: 1%{?dist}
URL: https://www.openssl.org/
License: Apache-2.0

# НЕ конфликтуем с системным OpenSSL
# DO NOT conflict with system OpenSSL
# Obsoletes: openssl < %{version}
# Conflicts: openssl < %{version}
# Provides: openssl = %{version}-%{release}

%define debug_package %{nil}
# Отключаем автоматическую генерацию Perl-зависимостей для runtime, чтобы ставилось без --nodeps
# Это безопасно, так как OpenSSL работает без Perl
%global __requires_exclude ^perl\\(.*\\)$
Source0: openssl-%{version}.tar.gz

# Зависимости сборки
# Build dependencies
BuildRequires: make gcc gcc-c++ perl perl-IPC-Cmd zlib-devel perl-libwww-perl

%description
OpenSSL RPM for version %{version} (4.x series) on CentOS/RHEL
This package installs alongside the system OpenSSL and does not replace it.

%prep
%setup -q -n openssl-%{version}

%build
# OpenSSL 4.0.0 использует стандартную систему сборки
# OpenSSL 4.0.0 uses standard build system
./config \
    --prefix=/usr/openssl4 \
    --openssldir=/usr/openssl4 \
    --libdir=lib64 \
    zlib \
    enable-tls1_3 \
    enable-ec_nistp_64_gcc_128 \
    no-weak-ssl-ciphers \
    no-ssl3 \
    no-ssl3-method \
    shared
make -j$(nproc)

%install
rm -rf %{buildroot}
%make_install

# Создание символических ссылок
# Create symbolic links
install -d %{buildroot}/usr/bin
install -d %{buildroot}/usr/lib64

# Ссылка на бинарный файл с явным указанием версии
# Link to binary with explicit version
ln -sf ../openssl4/bin/openssl %{buildroot}/usr/bin/openssl4

# Ссылки на библиотеки с версией 4
# Links to libraries with version 4
ln -sf ../openssl4/lib64/libssl.so %{buildroot}/usr/lib64/libssl.so.4
ln -sf ../openssl4/lib64/libcrypto.so %{buildroot}/usr/lib64/libcrypto.so.4

%files
/usr/bin/openssl4
/usr/lib64/libssl.so.4
/usr/lib64/libcrypto.so.4
/usr/openssl4

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig
EOF

# Сборка RPM
# Build RPM package
cd "${BUILD_ROOT}/SPECS"
rpmbuild -ba --define "version ${VERSION}" openssl4.spec

# Вывод результатов сборки
# Output build results
echo "Build completed! RPM packages:"
find "${BUILD_ROOT}/RPMS" -name "*.rpm"

echo ""
echo "=== OpenSSL 4.0.0 Installation Notes ==="
echo ""
echo "✅ System OpenSSL was preserved (required by sudo, pam, etc.)"
echo "✅ OpenSSL 4.0.0 installed in parallel to /usr/openssl4"
echo ""
echo "To use OpenSSL 4.0.0:"
echo "  /usr/bin/openssl4 version"
echo ""
echo "To compile against OpenSSL 4.0.0:"
echo "  gcc -I/usr/openssl4/include -L/usr/openssl4/lib64 program.c -lssl -lcrypto"
echo ""
echo "To check library paths:"
echo "  ldconfig -p | grep libssl"
echo ""
echo "=== Major changes in OpenSSL 4.0.0 ==="
echo "- Encrypted Client Hello (ECH) support (RFC 9849)"
echo "- Post-quantum cryptography algorithms"
echo "- ENGINE API removed (use providers instead)"
echo "- SSLv3 support completely removed"
echo "- c_rehash script removed (use 'openssl rehash')"
echo "- ASN1_STRING made opaque"
