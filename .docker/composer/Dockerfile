FROM composer:2.2.5 AS composer

FROM php:8.1-fpm-alpine3.15
COPY --from=composer /usr/bin/composer /usr/bin/composer 


# Install igbinary & memcached
RUN apk add --no-cache --update libmemcached-libs zlib libsodium-dev icu-dev
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
    apk del .memcached-deps .phpize-deps && \
    # Install & Enable PHP sodium extension
    docker-php-ext-install sodium intl && \
    docker-php-ext-configure intl && \
    docker-php-ext-enable sodium intl


# Install phpredis
RUN apk add --no-cache pcre-dev $PHPIZE_DEPS && \
    pecl update-channels && \
    pecl install redis && \
    docker-php-ext-enable redis && \
    apk del $PHPIZE_DEPS


WORKDIR /app/laravel/src

ENTRYPOINT ["/usr/bin/composer"]
