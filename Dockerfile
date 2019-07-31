FROM centos:7

RUN yum -y install \
    curl \
    which \
    make \
    gcc \
    perl \
    perl-WWW-Curl \
    rpm-build

# Get openssl tarball
RUN curl -O --silent https://www.openssl.org/source/openssl-1.1.1c.tar.gz

RUN mkdir -p /root/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
COPY /SPECS/* /root/rpmbuild/SPECS

RUN mv openssl-1.1.1c.tar.gz /root/rpmbuild/SOURCES
RUN cd /root/rpmbuild/SPECS && \
    rpmbuild \
    -D "version 1.1.1c" \
    -ba openssl.spec

# Try to install:  rpm -ivvh /root/rpmbuild/RPMS/x86_64/openssl-1.1.1c-1.el7.centos.x86_64.rpm
# I need --nodeps ??? Something is wrong

# Verify install:  rpm -qa openssl


#rpmbuild \
#    -D "dist ${dist}" \
#    -D "version ${buildver}" \
#    -D "release ${releasever}" \
#    -D "_topdir /rpmbuild" \
#    -ba rpm/pgbouncer.spec
