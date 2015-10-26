#!/bin/bash

apt-get install -y syslog-ng-core

sed -i -e 's/^#SYSLOGNG_OPTS.*$/SYSLOGNG_OPTS="--no-caps"/g' /etc/default/syslog-ng
sed -i -e 's/system();/unix-stream("\/dev\/log");/' \
       -e 's/^\(.*d_console.*\)$/#\1/' \
       -e 's/^\(\s*destination(d_xconsole.*\)$/#\1/' /etc/syslog-ng/syslog-ng.conf
