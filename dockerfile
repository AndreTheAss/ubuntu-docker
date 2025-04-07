FROM php:apache

# Update und benötigte Pakete installieren (z. B. unzip, curl) und PHP-Erweiterungen, wie pdo_mysql
RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    && docker-php-ext-install pdo_mysql

# Composer installieren
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Arbeitsverzeichnis setzen
WORKDIR /var/www/html

# composer.json kopieren und Abhängigkeiten installieren
COPY composer.json ./
RUN composer install --no-dev --optimize-autoloader

# Restlichen Quellcode kopieren
COPY . .

# Apache startet standardmäßig im Vordergrund (im php:apache Image bereits konfiguriert)
