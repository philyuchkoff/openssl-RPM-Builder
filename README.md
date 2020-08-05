# Build RPM OpenSSL version 1.1.1g (for CentOS 7)

:exclamation::exclamation::exclamation: [OpenSSL Security Advisory \[21 April 2020\]](https://www.openssl.org/news/secadv/20200421.txt)
**Version 1.1.1g NOT affected!**

## Build:

```bash
sudo yum groupinstall 'Development Tools'
git clone https://github.com/philyuchkoff/openssl-1.1.1g-RPM-Builder.git
cd openssl-1.1.1g-RPM-Builder/
chmod +x install-openssl_1.1.1g.sh 
./install-openssl_1.1.1g.sh
 ```
    
Builded RPM will be in

    /root/rpmbuild/RPMS/x86_64/
    
After `install-openssl_1.1.1g.sh` will finish, you can install builded rpm:

```bash
rpm -ivvh /root/rpmbuild/RPMS/x86_64/openssl-1.1.1g-1.el7.x86_64.rpm --nodeps
 ```   
## Check:

    openssl version

should be:

    OpenSSL 1.1.1g  21 Apr 2020
   
## I will gladly accept all comments

If you find this thing useful, you can buy me coffee as a thank you! :) But this is not necessary at all!

<a href="https://www.buymeacoffee.com/philyuchkoff" target="_blank"><img src="http://public.jc21.com/github/by-me-a-coffee.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a>
