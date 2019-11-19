# Сборка RPM OpenSSL версии 1.1.1d (для CentOS 7)


## Установка:

    sudo yum groupinstall 'Development Tools'
    git clone https://github.com/philyuchkoff/openssl-1.1.1d-RPM-Builder.git
    cd openssl-1.1.1d-RPM-Builder/
    chmod +x install-openssl_1.1.1d.sh 
    ./install-openssl_1.1.1d.sh
    
Собирается ООООООООООООЧЧЧЧЧЧЕЕЕЕЕЕЕЕЕЕЕНННННННННННЬЬЬЬЬЬЬЬЬЬ долго!!!

Собранный RPM будет лежать в 

    /opt/openssl-1.1.1d-RPM-Builder/rpmbuild/RPMS/x86_64
    
После того, как install-openssl_1.1.1d.sh отработает, попробуйте установить собранный пакет:

    rpm -ivvh /root/rpmbuild/RPMS/x86_64/openssl-1.1.1d-1.el7.x86_64.rpm --nodeps
    
## Проверка

После установки пакета можно проверить:

        openssl version
    
должно ответить так:

    OpenSSL 1.1.1d  10 Sep 2019
