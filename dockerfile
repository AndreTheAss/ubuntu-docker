FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Desktop-Umgebung und RDP (xrdp) installieren
RUN apt-get update && \
    apt-get install -y xfce4 xfce4-terminal xfce4-goodies xrdp sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Benutzer anlegen
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Standard-Desktop für RDP einrichten
RUN echo "startxfce4" > /home/docker/.xsession && chown docker:docker /home/docker/.xsession

# RDP-Port freigeben
EXPOSE 3389

CMD ["/usr/sbin/xrdp", "--nodaemon"]
