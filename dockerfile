FROM php:8.2-apache

# -------------------------------------------------------------------
# Apache: Rewrite aktivieren (für WordPress Permalinks)
# -------------------------------------------------------------------
RUN a2enmod rewrite

# -------------------------------------------------------------------
# PHP Extensions installieren (WordPress benötigt diese)
# -------------------------------------------------------------------
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql zip intl opcache exif \
    && docker-php-ext-enable exif

# -------------------------------------------------------------------
# WICHTIG: www-data UID und GID auf 1000 setzen
# Damit WordPress + SFTP-User gemeinsam schreiben können.
# -------------------------------------------------------------------
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

# -------------------------------------------------------------------
# Apache Document Root
# -------------------------------------------------------------------
WORKDIR /var/www/html

# -------------------------------------------------------------------
# Optional: OPcache optimieren (WordPress schneller)
# -------------------------------------------------------------------
RUN echo "opcache.enable=1\n\
opcache.memory_consumption=256\n\
opcache.interned_strings_buffer=16\n\
opcache.max_accelerated_files=20000\n\
opcache.validate_timestamps=1\n\
opcache.revalidate_freq=0\n" > /usr/local/etc/php/conf.d/opcache.ini

# -------------------------------------------------------------------
# Optional: Datei-/Ordnerrechte reparieren (sicher für WP)
# Wird nur beim Build gesetzt, nicht zur Laufzeit.
# -------------------------------------------------------------------
RUN chown -R www-data:www-data /var/www \
    && find /var/www -type d -exec chmod 775 {} \; \
    && find /var/www -type f -exec chmod 664 {} \;




