# OpenSSL v.1.1.1m (11-Feb-2022) RPM builder for CentOS 7
![GitHub last commit](https://img.shields.io/github/last-commit/philyuchkoff/openssl-RPM-Builder?style=for-the-badge)
![GitHub All Releases](https://img.shields.io/github/downloads/philyuchkoff/openssl-RPM-Builder/total?style=for-the-badge)

## [OpenSSL](https://www.openssl.org/)
## Build:

```bash
sudo yum groupinstall 'Development Tools'
git clone https://github.com/cnrock/openssl-RPM-Builder
cd openssl-1.1.1m-RPM-Builder/
chmod +x install-openssl_1.1.1m.sh 
./install-openssl_1.1.1m.sh
 ```
    
Builded RPM will be in

    /root/rpmbuild/RPMS/x86_64/
    
After `install-openssl_1.1.1m.sh` will finish, you can install builded rpm:

```bash
rpm -ivvh /root/rpmbuild/RPMS/x86_64/openssl-1.1.1m-1.el7.x86_64.rpm --nodeps
 ```   
## Check:

    $openssl version
    OpenSSL 1.1.1m  11 Feb 2022
or

    $rpm -qa openssl
    openssl-1.1.1m-1.el7.x86_64
  
