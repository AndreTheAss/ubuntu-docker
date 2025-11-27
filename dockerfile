FROM php:8.2-apache

# Apache Rewrite aktivieren (für Permalinks)
RUN a2enmod rewrite

# PHP Extensions installieren
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql zip intl opcache exif

# Dokumentroot korrekt setzen
WORKDIR /var/www/html

