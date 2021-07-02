# OpenSSL v.1.1.1k (25-Mar-2021) RPM builder for CentOS 7
![GitHub last commit](https://img.shields.io/github/last-commit/philyuchkoff/openssl-RPM-Builder?style=for-the-badge)
![GitHub All Releases](https://img.shields.io/github/downloads/philyuchkoff/openssl-RPM-Builder/total?style=for-the-badge)

## [OpenSSL](https://www.openssl.org/)

## Remove old versions
````rpm -qa | grep openssl
rpm -e --justdb --nodeps <yourpackage>
````

## Build:

```bash
sudo yum groupinstall 'Development Tools'
git clone https://github.com/philyuchkoff/openssl-RPM-Builder
cd openssl-RPM-Builder
chmod +x install-openssl_1.1.1.sh 
sudo ./install-openssl_1.1.1.sh
 ```
    
Builded RPM will be in

    /root/rpmbuild/RPMS/x86_64/
    
After `install-openssl_1.1.1.sh` will finish, you can install builded rpm:

```bash
sudo rpm -ivvh /root/rpmbuild/RPMS/x86_64/openssl-1.1.1k-1.el7.x86_64.rpm --nodeps
 ```   
## Check:

    $openssl version
    OpenSSL 1.1.1k  25 Mar 2021
or

    $rpm -qa openssl
    openssl-1.1.1k-1.el7.x86_64
  
