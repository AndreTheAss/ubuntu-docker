FROM php:8-apache

# Update und Installation von vsftpd
RUN apt-get update && apt-get install -y vsftpd && apt-get clean

# Kopiere die FTP-Server-Konfiguration in das Image
COPY vsftpd.conf /etc/vsftpd.conf

# Erstelle einen FTP-Benutzer (bitte in der Produktion sichere Zugangsdaten verwenden)
RUN useradd -m ftpuser && echo "ftpuser:ftp_password" | chpasswd

# Exponiere die notwendigen Ports: 80 (Apache), 21 (FTP) sowie den Bereich für passive FTP-Verbindungen
EXPOSE 80 21 30000-30009

# Kopiere das Entrypoint-Skript, das beide Dienste startet
COPY entrypoint.sh /usr/local/bin/docker-php-entrypoint/entrypoint.sh
RUN chmod +x /usr/local/bin/docker-php-entrypoint/entrypoint.sh

CMD ["/entrypoint.sh"]
