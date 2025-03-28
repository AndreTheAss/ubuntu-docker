FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Update und Installation der notwendigen Pakete
RUN apt-get update && \
    apt-get install -y xfce4 xfce4-terminal xfce4-goodies xrdp sudo openssh-server supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# SSH konfigurieren: Verzeichnis für den SSH-Daemon erstellen und Port anpassen
RUN mkdir /var/run/sshd && \
    sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config

# Benutzer anlegen (z. B. "docker") und in die sudo-Gruppe aufnehmen
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Standard-Desktop (XFCE) für RDP einrichten
RUN echo "startxfce4" > /home/docker/.xsession && chown docker:docker /home/docker/.xsession

# Exponierte Ports: 3389 für RDP, 2222 für SSH
EXPOSE 3389 2222

# Supervisord-Konfiguration kopieren
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Supervisor startet alle Dienste im Vordergrund
CMD ["/usr/bin/supervisord", "-n"]
