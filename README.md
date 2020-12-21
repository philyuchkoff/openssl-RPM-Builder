# Build RPM OpenSSL version 1.1.1i (08-Dec-2020) for CentOS 7
![GitHub last commit](https://img.shields.io/github/last-commit/philyuchkoff/openssl-RPM-Builder?style=for-the-badge)
![GitHub All Releases](https://img.shields.io/github/downloads/philyuchkoff/openssl-RPM-Builder/total?style=for-the-badge)

## [OpenSSL](https://www.openssl.org/)
## Build:

```bash
sudo yum groupinstall 'Development Tools'
git clone https://github.com/philyuchkoff/openssl-1.1.1-RPM-Builder.git
cd openssl-1.1.1i-RPM-Builder/
chmod +x install-openssl_1.1.1i.sh 
./install-openssl_1.1.1i.sh
 ```
    
Builded RPM will be in

    /root/rpmbuild/RPMS/x86_64/
    
After `install-openssl_1.1.1i.sh` will finish, you can install builded rpm:

```bash
rpm -ivvh /root/rpmbuild/RPMS/x86_64/openssl-1.1.1i-1.el7.x86_64.rpm --nodeps
 ```   
## Check:

    openssl version
or

    rpm -qa openssl
   
#### If you find this thing useful, you can buy me coffee as a thank you! :) 
But this is not necessary at all!

<a href="https://www.buymeacoffee.com/philyuchkoff" target="_blank"><img src="http://public.jc21.com/github/by-me-a-coffee.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a>
