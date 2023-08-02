# OpenSSL rpm builder for CentOS 7 - build latest OpenSSL binary

![GitHub last commit](https://img.shields.io/github/last-commit/philyuchkoff/openssl-RPM-Builder?style=for-the-badge)
![GitHub All Releases](https://img.shields.io/github/downloads/philyuchkoff/openssl-RPM-Builder/total?style=for-the-badge)

## [OpenSSL](https://www.openssl.org/)

- [openssl-3.1.2-1.el7.x86_64.rpm](https://github.com/philyuchkoff/openssl-RPM-Builder/releases)
- [openssl-1.1.1v-1.el7.x86_64.rpm](https://github.com/philyuchkoff/openssl-RPM-Builder/releases)

[OpenSSL 1.1.1 End of Life](https://www.openssl.org/blog/blog/2023/03/28/1.1.1-EOL/)

## Remove old versions
````
rpm -qa | grep openssl
rpm -e --justdb --nodeps <yourpackage>
````

# OpenSSL 1.1.1v:

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
sudo rpm -ivvh /root/rpmbuild/RPMS/x86_64/openssl-1.1.1v-1.el7.x86_64.rpm --nodeps
 ```   

## Check:

    $openssl version
    OpenSSL 1.1.1v  01 Aug 2023
or

    $rpm -qa openssl
    openssl-1.1.1v-1.el7.x86_64
  
# OpenSSL 3.1.2:

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
sudo rpm -ivvh /root/rpmbuild/RPMS/x86_64/openssl-3.1.2-1.el7.x86_64.rpm --nodeps
 ```  
