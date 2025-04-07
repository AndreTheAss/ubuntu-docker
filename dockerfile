FROM php:apache

# Update und benötigte Pakete installieren (z. B. unzip für Composer)
RUN apt-get update && apt-get install -y unzip curl

# Composer installieren
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Arbeitsverzeichnis setzen
WORKDIR /var/www/html

# Composer-Dateien kopieren und Abhängigkeiten installieren
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader

# Restlichen Quellcode kopieren
COPY . .

# Apache im Vordergrund starten (normalerweise ist das bereits im php:apache Image konfiguriert)
