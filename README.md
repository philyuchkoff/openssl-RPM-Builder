# Сборка RPM OpenSSL версии 1.1.1e (для CentOS 7)

## Установка:

    sudo yum groupinstall 'Development Tools'
    git clone https://github.com/philyuchkoff/openssl-1.1.1e-RPM-Builder.git
    cd openssl-1.1.1e-RPM-Builder/
    chmod +x install-openssl_1.1.1e.sh 
    ./install-openssl_1.1.1e.sh
    
Собирается ООООООООООООЧЧЧЧЧЧЕЕЕЕЕЕЕЕЕЕЕНННННННННННЬЬЬЬЬЬЬЬЬЬ долго!!!

Собранный RPM будет лежать в 

    /opt/openssl-1.1.1e-RPM-Builder/rpmbuild/RPMS/x86_64
    
После того, как install-openssl_1.1.1e.sh отработает, попробуйте установить собранный пакет:

    rpm -ivvh /root/rpmbuild/RPMS/x86_64/openssl-1.1.1e-1.el7.x86_64.rpm --nodeps
    
## Проверка

После установки пакета можно проверить:

    openssl version
    
должно ответить так:

    OpenSSL 1.1.1e  17 Mar 2020

## С удовольствием приму все замечания

Если вам пригодилась эта штука - можно в качестве благодарности купить мне кофе! :) Но это совершенно не обязательно!

<a href="https://www.buymeacoffee.com/philyuchkoff" target="_blank"><img src="http://public.jc21.com/github/by-me-a-coffee.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a>
