# OpenSSL rpm builder for CentOS 7 - build latest OpenSSL binary
![GitHub last commit](https://img.shields.io/github/last-commit/philyuchkoff/openssl-RPM-Builder?style=for-the-badge)
![GitHub All Releases](https://img.shields.io/github/downloads/philyuchkoff/openssl-RPM-Builder/total?style=for-the-badge)

## [OpenSSL](https://www.openssl.org/)

- [openssl-3.0.4-1.el7.x86_64.rpm](https://github.com/philyuchkoff/openssl-RPM-Builder/releases)
- [openssl-1.1.1p-1.el7.x86_64.rpm](https://github.com/philyuchkoff/openssl-RPM-Builder/releases)

## Remove old versions
````
rpm -qa | grep openssl
rpm -e --justdb --nodeps <yourpackage>
````

# OpenSSL 1.1.1p:

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
sudo rpm -ivvh /root/rpmbuild/RPMS/x86_64/openssl-1.1.1p-1.el7.x86_64.rpm --nodeps
 ```   

## Check:

    $openssl version
    OpenSSL 1.1.1p  21 Jun 2022
or

    $rpm -qa openssl
    openssl-1.1.1p-1.el7.x86_64
  
# OpenSSL 3:

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

# Thanks to supporters!
[![Stargazers repo roster for @philyuchkoff/openssl-RPM-Builder](https://reporoster.com/stars/philyuchkoff/openssl-RPM-Builder)](https://github.com/philyuchkoff/openssl-RPM-Builder/stargazers)

[![Forkers repo roster for @philyuchkoff/openssl-RPM-Builder](https://reporoster.com/forks/philyuchkoff/openssl-RPM-Builder)](https://github.com/philyuchkoff/openssl-RPM-Builder/network/members)
