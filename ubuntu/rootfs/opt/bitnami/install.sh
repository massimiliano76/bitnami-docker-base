#!/bin/bash
set -e

# Just COPY the installer.run to /tmp to skip download
echo "===> Downloading Bitnami $BITNAMI_APP_NAME-$BITNAMI_APP_VERSION installer"
if [ -f /tmp/installer.run ]; then
  echo "===> /tmp/installer.run already exists, skipping download."
else
  BITNAMI_INSTALLER_VERSION=$(echo $BITNAMI_APP_VERSION | awk -F"-r" '{print $1}')
  if [ "x$BITNAMI_FILENAME_PREFIX" = "x" ] ; then
    BITNAMI_FILENAME_PREFIX="bitnami-"
  fi
  if [ "x$IS_BITNAMI_STACK" = "x" ] ; then
    BITNAMI_APP_FILENAME=$BITNAMI_FILENAME_PREFIX$BITNAMI_APP_NAME-$BITNAMI_INSTALLER_VERSION-container-linux-x64-installer.run
    url=https://downloads.bitnami.com/files/download/containers/$BITNAMI_APP_NAME/$BITNAMI_APP_FILENAME
  else
    BITNAMI_APP_FILENAME=$BITNAMI_FILENAME_PREFIX$BITNAMI_APP_NAME-$BITNAMI_INSTALLER_VERSION-linux-x64-installer.run
    url=https://downloads.bitnami.com/files/stacks/$BITNAMI_APP_NAME/$BITNAMI_APP_VERSION/$BITNAMI_APP_FILENAME
  fi
  echo $url
  if [ $SHOW_PROGRESS ]; then
    curl -SL --progress-bar $url -o /tmp/installer.run
  else
    curl -SLs $url -o /tmp/installer.run
  fi
fi

if [ -f /tmp/installer.run.sha256 ]; then
  echo "===> Checking installer integrity"
  sha256sum -c --quiet /tmp/installer.run.sha256
else
  echo "===> Warning, installer sha256 file not found, integrity check skipped"
fi

echo "===> Running Bitnami $BITNAMI_APP_NAME-$BITNAMI_APP_VERSION installer"
# Fix for busy text error if added the installer from the Dockerfile
if [ ! -x /tmp/installer.sh ]; then
  chmod +x /tmp/installer.run
fi
sync /tmp/installer.run

/tmp/installer.run --mode unattended --prefix $BITNAMI_PREFIX $@

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
  echo "===> Executing post-install script"
  . /tmp/post-install.sh
fi

rm -rf $BITNAMI_PREFIX/manager-linux-x64.run \
  $BITNAMI_PREFIX/uninstall $BITNAMI_PREFIX/uninstall.dat \
  tmp/*

if [ "x$IS_BITNAMI_STACK" = "x" ] ; then
  rm -rf $BITNAMI_PREFIX/ctlscript.sh \
    $BITNAMI_PREFIX/config
else
  echo "===> Stopping all services"
  $BITNAMI_PREFIX/ctlscript.sh stop
  mv $BITNAMI_PREFIX/apps $BITNAMI_PREFIX/apps.bak
fi
