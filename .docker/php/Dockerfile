FROM php:8.3-fpm-alpine3.17

RUN apk add --update libpq-dev libsodium-dev icu-dev linux-headers && \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
    docker-php-ext-configure intl && \
    docker-php-ext-configure pcntl --enable-pcntl && \
    docker-php-ext-install pdo pdo_pgsql pgsql mysqli pdo_mysql sodium intl pcntl && \
    docker-php-ext-enable pdo_mysql sodium intl

RUN apk add --no-cache $PHPIZE_DEPS && \
    # pecl install xdebug-3.1.3 && \
    pecl install xdebug-3.3.0 && \
    docker-php-ext-enable xdebug


# Install igbinary & memcached
RUN apk add --no-cache --update libmemcached-libs zlib
RUN set -xe && \
    cd /tmp/ && \
    apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS && \
    apk add --no-cache --update --virtual .memcached-deps zlib-dev libmemcached-dev cyrus-sasl-dev && \
    # Install igbinary (memcached's deps)
    pecl install igbinary && \
    # Install memcached
    ( \
    pecl install --nobuild memcached && \
    cd "$(pecl config-get temp_dir)/memcached" && \
    phpize && \
    ./configure --enable-memcached-igbinary && \
    make -j$(nproc) && \
    make install && \
    cd /tmp/ \
    ) && \
    # Enable PHP extensions
    docker-php-ext-enable igbinary memcached && \
    rm -rf /tmp/* && \
    apk del .memcached-deps .phpize-deps


# Install phpredis
RUN apk add --no-cache pcre-dev $PHPIZE_DEPS && \
    pecl update-channels && \
    pecl install redis && \
    docker-php-ext-enable redis && \
    apk del $PHPIZE_DEPS


RUN addgroup -g 1000 php
RUN adduser -u 1000 -G php -D php

RUN mkdir /var/log/php

RUN chown -R php:php /var/log/

# Set php-fpm process to run with same uid:gid as nginx subprocess
# Allows nginx to serve static files without calling php
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

USER 1000:1000

