FROM bitnami/base-ubuntu:14.04
MAINTAINER Bitnami <containers@bitnami.com>

#Copying initialization, common and util scripts
COPY rootfs/ /

#Updating package repositories and:
#  - installing syslog-ng service
#  - installing vsftpd.sh service
#  - cleanup
RUN apt-get update && \
      /tmp/install_syslog-ng.sh && rm /tmp/install_syslog-ng.sh && \
      /tmp/install_vsftpd.sh && rm /tmp/install_vsftpd.sh && \
      apt-get clean && rm -rf /var/lib/apt /var/cache/apt/archives/* /tmp/*

WORKDIR /workdir
