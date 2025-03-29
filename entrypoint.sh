#!/bin/bash
# Starte den FTP-Dienst (vsftpd) im Hintergrund
service vsftpd start

# Starte Apache im Vordergrund
exec apache2-foreground
