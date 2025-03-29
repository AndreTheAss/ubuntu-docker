#!/bin/bash
/usr/sbin/vsftpd /etc/vsftpd.conf &
exec apache2-foreground
