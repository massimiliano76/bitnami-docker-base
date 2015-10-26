#!/bin/bash

BITNAMI_USER=bitnami
FTP_USER=bitnamiftp
CONF_FILE=/etc/vsftpd.conf

apt-get install -y vsftpd
mkdir -p /var/run/vsftpd/empty

sed -i -e 's/^\s*listen=/#listen=/g' \
       -e 's/^\s*listen_ipv6=/#listen_ipv6=/g' \
       -e 's/^\s*listen_address=/#listen_address=/g' \
       -e 's/^\s*anonymous_enable/#anonymous_enable=/g' \
       -e 's/^\s*write_enable=/#write_enable=/g' \
       -e 's/^\s*local_enable=/#local_enable=/g' \
       -e 's/^\s*local_umask=/#local_umask=/g' $CONF_FILE
echo "
listen=YES
listen_address=127.0.0.1
write_enable=YES
local_enable=YES
anonymous_enable=NO
local_umask=022
userlist_enable=YES
userlist_deny=NO
userlist_file=/etc/vsftpd.allowed_users" >> $CONF_FILE

echo "$FTP_USER" > /etc/vsftpd.allowed_users
cp /bin/false /bin/bitnami_ftp_false
echo "
/bin/bitnami_ftp_false" >> /etc/shells
useradd $BITNAMI_USER
useradd -s /bin/bitnami_ftp_false -M -d $BITNAMI_PREFIX/apps -o -u `id -u $BITNAMI_USER` -g `id -g $BITNAMI_USER` bitnamiftp
