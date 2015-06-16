FROM ubuntu-debootstrap:14.04
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_PREFIX=/opt/bitnami

# Create bitnami user and added specific requirements
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y curl ca-certificates sudo && \
  curl -o /usr/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" && \
  chmod +x /usr/bin/gosu && \
  echo '#!/bin/bash\n. $BITNAMI_PREFIX/bitnami-utils.sh\nprint_bitnami_help_page' > '/usr/bin/print-help' && \
  echo '#!/bin/bash\n. $BITNAMI_PREFIX/bitnami-utils.sh\ncheck_for_updates' > '/usr/bin/check-updates' && \
  chmod a+x /usr/bin/print-help /usr/bin/check-updates && \
  adduser bitnami --disabled-password --gecos "" && \
  sed -i -e 's/\s*Defaults\s*secure_path\s*=/# Defaults secure_path=/' /etc/sudoers && \
  echo "bitnami ALL=NOPASSWD: ALL" >> /etc/sudoers && \
  apt-get clean && \
  rm -rf /var/lib/apt /var/cache/apt/archives/* /tmp/*

COPY install.sh $BITNAMI_PREFIX/install.sh
COPY bitnami-utils.sh $BITNAMI_PREFIX/bitnami-utils.sh
