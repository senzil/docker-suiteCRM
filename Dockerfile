ARG php_version=7-apache
FROM php:${php_version}
LABEL maintainer="pablodgonzalez@gmail.com"
ARG suitecrm_version=7.10.11

COPY php.suitecrm.ini /usr/local/etc/php/conf.d/
COPY crons.suitecrm.conf /etc/cron.d/

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y libc-client-dev libkrb5-dev libcurl4-gnutls-dev libpng-dev libzip-dev unzip git cron vim netcat && \
    docker-php-ext-configure imap --with-imap-ssl --with-kerberos && \
    docker-php-ext-install mysqli curl gd zip mbstring imap pdo pdo_mysql && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    crontab -u www-data /etc/cron.d/crons.suitecrm.conf

RUN curl -OL https://github.com/salesagility/SuiteCRM/archive/v${suitecrm_version}.tar.gz && \
    tar xvfz v${suitecrm_version}.tar.gz --strip 1 -C /var/www/html && \
    composer install && \
    chown -R www-data:www-data . && \
    chmod -R 755 .

VOLUME /var/www/html/upload
EXPOSE 80

COPY config_si.php .
COPY suitecrm-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["suitecrm-entrypoint.sh"]
CMD ["apache2-foreground"]