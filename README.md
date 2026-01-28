# OpenSSL rpm builder for CentOS/RHEL - build latest OpenSSL binary

![GitHub last commit](https://img.shields.io/github/last-commit/philyuchkoff/openssl-RPM-Builder?style=for-the-badge)
![GitHub All Releases](https://img.shields.io/github/downloads/philyuchkoff/openssl-RPM-Builder/total?style=for-the-badge)

## [OpenSSL official site](https://www.openssl.org/)

## Remove old versions
````
rpm -qa | grep openssl
rpm -e --justdb --nodeps <yourpackage>
````
  
# OpenSSL 3.6.1 [release page](https://github.com/openssl/openssl/releases/tag/openssl-3.6.1):

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
sudo rpm -ivvh /root/rpmbuild/RPMS/x86_64/openssl-3.6.1-1.el9.x86_64.rpm --nodeps
 ```

# OpenSSL 1.1.1w:
[OpenSSL 1.1.1 End of Life](https://www.openssl.org/blog/blog/2023/03/28/1.1.1-EOL/)

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
sudo rpm -ivvh /root/rpmbuild/RPMS/x86_64/openssl-1.1.1w-1.el7.x86_64.rpm --nodeps
 ```   

## Check:

    $openssl version
    OpenSSL 1.1.1w  11 Sep 2023
or

    $rpm -qa openssl
    openssl-1.1.1w-1.el7.x86_64

## For fun

[![Star History Chart](https://api.star-history.com/svg?repos=philyuchkoff/openssl-RPM-Builder&type=date&legend=top-left)](https://www.star-history.com/#philyuchkoff/openssl-RPM-Builder&type=date&legend=top-left)
