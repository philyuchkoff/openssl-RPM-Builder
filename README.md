# OpenSSL RPM Builder for CentOS/RHEL

![GitHub Release (latest by date)](https://img.shields.io/github/v/release/philyuchkoff/openssl-RPM-Builder?style=for-the-badge)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/philyuchkoff/openssl-RPM-Builder/release.yml?style=for-the-badge)
![GitHub All Releases](https://img.shields.io/github/downloads/philyuchkoff/openssl-RPM-Builder/total?style=for-the-badge)
![GitHub last commit](https://img.shields.io/github/last-commit/philyuchkoff/openssl-RPM-Builder?style=for-the-badge)

## [OpenSSL official site](https://www.openssl.org/)

---

## Pre-built RPMs (recommended)

Ready-to-use RPM packages for CentOS/RHEL 8/9 are available on [GitHub Releases](https://github.com/philyuchkoff/openssl-RPM-Builder/releases):

```bash
VER=4.0.1
wget https://github.com/philyuchkoff/openssl-RPM-Builder/releases/download/openssl-${VER}/openssl4-${VER}-1.el8.x86_64.rpm
sudo rpm -ivh openssl4-${VER}-1.el8.x86_64.rpm
```

---

# OpenSSL 4.x

## Build:

```bash
sudo dnf -y groupinstall 'Development Tools'
git clone https://github.com/philyuchkoff/openssl-RPM-Builder
cd openssl-RPM-Builder
chmod +x install-openssl_4.sh
sudo ./install-openssl_4.sh
```

Or via Makefile:
```bash
sudo make install-4
```

Built RPM location:

```
/root/rpmbuild/RPMS/x86_64/
```

After the script finishes, install the RPM:

```bash
sudo rpm -ivh /root/rpmbuild/RPMS/x86_64/openssl4-4.0.1-1.el9.x86_64.rpm
```

### Installation

- System OpenSSL preserved (required by sudo, pam, etc.)
- OpenSSL 4.x installed in parallel to `/usr/openssl4`

To use OpenSSL 4.x:

```bash
/usr/bin/openssl4 version
```

To compile against OpenSSL 4.x:

```bash
gcc -I/usr/openssl4/include -L/usr/openssl4/lib64 program.c -lssl -lcrypto
```

To check library paths:

```bash
ldconfig -p | grep libssl
```

v4.0.0 [release page](https://github.com/openssl/openssl/releases/tag/openssl-4.0.0)
v4.0.1 [release page](https://github.com/openssl/openssl/releases/tag/openssl-4.0.1)

---

# OpenSSL 3.x

## Build:

```bash
sudo dnf -y groupinstall 'Development Tools'
git clone https://github.com/philyuchkoff/openssl-RPM-Builder
cd openssl-RPM-Builder
chmod +x install-openssl_3.sh
sudo ./install-openssl_3.sh
```

Built RPM location:

```
/root/rpmbuild/RPMS/x86_64/
```

After the script finishes, install the RPM:

```bash
sudo rpm -ivh /root/rpmbuild/RPMS/x86_64/openssl-3.6.2-1.el9.x86_64.rpm --nodeps
```

v3.6.2 [release page](https://github.com/openssl/openssl/releases/tag/openssl-3.6.2)

---

# OpenSSL 1.1.1

[End of Life](https://www.openssl.org/blog/blog/2023/03/28/1.1.1-EOL/)

## Check:

```
$openssl version
OpenSSL 1.1.1w  11 Sep 2023
```
or

```
$rpm -qa openssl
openssl-1.1.1w-1.el7.x86_64
```
