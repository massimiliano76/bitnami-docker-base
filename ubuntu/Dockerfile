FROM ubuntu-debootstrap:14.04
MAINTAINER Bitnami

ENV BITNAMI_PREFIX=/usr/local/bitnami
COPY install.sh $BITNAMI_PREFIX/install.sh
COPY bitnami-utils.sh $BITNAMI_PREFIX/bitnami-utils.sh

ONBUILD COPY help.txt $BITNAMI_PREFIX/help.txt
ONBUILD COPY installer.run.sha256 /tmp/installer.run.sha256
ONBUILD COPY post-install.sh /tmp/post-install.sh

# Create bitnami user and added specific requirements
RUN apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y curl sudo &&\
  curl -o /usr/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" && \
  chmod +x /usr/bin/gosu &&\
  echo '#!bin/sh\n. $BITNAMI_PREFIX/bitnami-utils.sh\nprint_bitnami_help_page' > '/usr/bin/bitnami-help' &&\
  chmod +x '/usr/bin/bitnami-help' &&\
  adduser bitnami --disabled-password --gecos "" &&\
  sed -i -e 's/\s*Defaults\s*secure_path\s*=/# Defaults secure_path=/' /etc/sudoers &&\
  echo "bitnami ALL=NOPASSWD: ALL" >> /etc/sudoers &&\
  rm -rf $BITNAMI_PREFIX/ctlscript.sh \
    $BITNAMI_PREFIX/config \
    $BITNAMI_PREFIX/manager-linux-x64.run \
    $BITNAMI_PREFIX/uninstall $BITNAMI_PREFIX/uninstall.dat \
    /var/lib/apt /var/cache/apt/archives/* /tmp/* && \
  apt-get clean


