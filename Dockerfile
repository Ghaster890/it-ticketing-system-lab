FROM php:8.3-apache-bookworm

ARG OSTICKET_REF=v1.18.4

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git libfreetype6-dev libicu-dev libjpeg62-turbo-dev libonig-dev libpng-dev libxml2-dev libzip-dev unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install dom \
    && CFLAGS="-I/usr/src/php" docker-php-ext-install -j"$(nproc)" xmlreader \
    && docker-php-ext-install -j"$(nproc)" gd gettext intl mbstring mysqli opcache pdo_mysql simplexml xml xmlwriter zip \
    && a2enmod headers rewrite \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch "${OSTICKET_REF}" https://github.com/osTicket/osTicket.git /tmp/osticket \
    && php /tmp/osticket/manage.php deploy --setup /var/www/html \
    && rm -rf /tmp/osticket \
    && mkdir -p /var/lib/osticket-config /var/www/html/attachments \
    && rm -f /var/www/html/include/ost-config.php \
    && ln -s /var/lib/osticket-config/ost-config.php /var/www/html/include/ost-config.php \
    && chown -R www-data:www-data /var/www/html /var/lib/osticket-config

COPY docker/apache-osticket.conf /etc/apache2/conf-available/osticket.conf
COPY docker/entrypoint.sh /usr/local/bin/osticket-entrypoint

RUN a2enconf osticket && chmod 0755 /usr/local/bin/osticket-entrypoint

WORKDIR /var/www/html
EXPOSE 80
ENTRYPOINT ["/usr/local/bin/osticket-entrypoint"]
CMD ["apache2-foreground"]

