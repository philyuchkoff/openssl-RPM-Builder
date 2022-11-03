# OpenSSL rpm builder for CentOS 7 - build latest OpenSSL binary

![GitHub last commit](https://img.shields.io/github/last-commit/philyuchkoff/openssl-RPM-Builder?style=for-the-badge)
![GitHub All Releases](https://img.shields.io/github/downloads/philyuchkoff/openssl-RPM-Builder/total?style=for-the-badge)

### [CVE-2022-3602](https://www.openssl.org/news/secadv/20221101.txt) The vulnerability is present in products using OpenSSL 3.0.0-3.0.6. Products that use OpenSSL 1.0.2 or 1.1.1 are not affected.
### [2022 OpenSSL vulnerability](https://github.com/NCSC-NL/OpenSSL-2022) - this repo contains operational information regarding the recently announced vulnerability in OpenSSL 3.
### cve-2022-3602 , cve-2022-3786 - [openssl-poc](https://github.com/rbowes-r7/cve-2022-3602-and-cve-2022-3786-openssl-poc)

## [OpenSSL](https://www.openssl.org/)

- [openssl-3.0.7-1.el7.x86_64.rpm](https://github.com/philyuchkoff/openssl-RPM-Builder/releases)
- [openssl-1.1.1s-1.el7.x86_64.rpm](https://github.com/philyuchkoff/openssl-RPM-Builder/releases)

## Remove old versions
````
rpm -qa | grep openssl
rpm -e --justdb --nodeps <yourpackage>
````

# OpenSSL 1.1.1s:

## Build:

```bash
sudo yum -y groupinstall 'Development Tools'
git clone https://github.com/philyuchkoff/openssl-RPM-Builder
cd openssl-RPM-Builder
chmod +x install-openssl_1.1.1.sh 
sudo ./install-openssl_1.1.1.sh
 ```
 
Builded RPM will be in

    /root/rpmbuild/RPMS/x86_64/
    
After `install-openssl_1.1.1.sh` will finish, you can install builded rpm:

```bash
sudo rpm -ivvh /root/rpmbuild/RPMS/x86_64/openssl-1.1.1s-1.el7.x86_64.rpm --nodeps
 ```   

## Check:

    $openssl version
    OpenSSL 1.1.1s  01 Nov 2022
or

    $rpm -qa openssl
    openssl-1.1.1s-1.el7.x86_64
  
# OpenSSL 3.0.7:

## Build:

```bash
sudo yum -y groupinstall 'Development Tools'
git clone https://github.com/philyuchkoff/openssl-RPM-Builder
cd openssl-RPM-Builder
chmod +x install-openssl_3.sh 
sudo ./install-openssl_3.sh
 ```
 
 Builded RPM will be in

    /root/rpmbuild/RPMS/x86_64/
    
After `install-openssl_3.sh` will finish, you can install builded rpm:

```bash
sudo rpm -ivvh /root/rpmbuild/RPMS/x86_64/openssl-3.0.7-1.el7.x86_64.rpm --nodeps
 ```  
