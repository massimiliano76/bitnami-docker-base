#!/bin/bash
set -e

# Just COPY the installer.run to /tmp to skip download
echo "===> Downloading Bitnami $BITNAMI_APP_NAME-$BITNAMI_APP_VERSION installer"
if [ -f /tmp/installer.run ]; then
  echo "===> /tmp/installer.run already exists, skipping download."
else
  BITNAMI_INSTALLER_VERSION=$(echo $BITNAMI_APP_VERSION | awk -F"-r" '{print $1}')
  if [ "x$IS_BITNAMI_STACK" = "x" ] ; then
    BITNAMI_APP_FILENAME=bitnami-$BITNAMI_APP_NAME-$BITNAMI_INSTALLER_VERSION-container-linux-x64-installer.run
    url=https://downloads.bitnami.com/files/download/containers/$BITNAMI_APP_NAME/$BITNAMI_APP_FILENAME
  else
    BITNAMI_APP_FILENAME=bitnami-$BITNAMI_APP_NAME-$BITNAMI_INSTALLER_VERSION-linux-x64-installer.run
    url=https://downloads.bitnami.com/files/stacks/$BITNAMI_APP_NAME/$BITNAMI_APP_VERSION/$BITNAMI_APP_FILENAME
  fi
  DOWNLOADED_INSTALLER=/tmp/$BITNAMI_APP_NAME-$BITNAMI_APP_VERSION-installer.run
  echo $url
  if [ $SHOW_PROGRESS ]; then
    curl -SL --progress-bar $url -o $DOWNLOADED_INSTALLER
  else
    curl -SLs $url -o $DOWNLOADED_INSTALLER
  fi
fi

if [ -f ${DOWNLOADED_INSTALLER}.sha256 ]; then
  echo "===> Checking installer integrity"
  sha256sum -c --quiet ${DOWNLOADED_INSTALLER}.sha256
else
  echo "===> Warning, installer sha256 file not found, integrity check skipped"
fi

echo "===> Running Bitnami $BITNAMI_APP_NAME-$BITNAMI_APP_VERSION installer"
# Fix for busy text error if added the installer from the Dockerfile
if [ ! -x /tmp/installer.sh ]; then
  chmod +x $DOWNLOADED_INSTALLER
fi
sync $DOWNLOADED_INSTALLER

$DOWNLOADED_INSTALLER --mode unattended --prefix $BITNAMI_PREFIX $@

if [ -f $BITNAMI_APP_DIR/scripts/ctl.sh  ]; then
  $BITNAMI_APP_DIR/scripts/ctl.sh stop > /dev/null
fi

if [ $BITNAMI_APP_VOL_PREFIX ]; then
  mkdir -p $BITNAMI_APP_VOL_PREFIX
fi

if [ -f "$BITNAMI_PREFIX/bitnami-utils.sh" ]; then
  chown $BITNAMI_APP_USER:$BITNAMI_APP_USER $BITNAMI_PREFIX/bitnami-utils.sh
fi

if [ -f "/tmp/post-install.sh" ]; then
  sh /tmp/post-install.sh
fi

rm -rf $BITNAMI_PREFIX/manager-linux-x64.run \
  $BITNAMI_PREFIX/uninstall $BITNAMI_PREFIX/uninstall.dat \
  $DOWNLOADED_INSTALLER \
  tmp/*

if [ "x$IS_BITNAMI_STACK" = "x" ] ; then
  echo "DELETING CTLSCRIPT!!"
  rm -rf $BITNAMI_PREFIX/ctlscript.sh \
    $BITNAMI_PREFIX/config
fi
