FROM alpine:latest
MAINTAINER Charlie Francis <charliefrancis@gmail.com>

# Install CURL & PHP
RUN apk --update add \
    bash \
    curl \
    nodejs \
    tini \
    php5 \
    php5-apcu php5-bcmath php5-ctype php5-curl php5-dom \
    php5-exif php5-gd php5-iconv php5-intl php5-json \
    php5-libsodium php5-mysqli php5-opcache php5-openssl php5-pcntl \
    php5-pdo_mysql php5-pdo_pgsql php5-pdo_sqlite php5-phar php5-posix \
    php5-xml php5-xsl php5-zip php5-zlib php5-fpm php5-mcrypt \
    unzip \
    sudo \
    wget

COPY config/php/php.ini /etc/php/conf.d/50-setting.ini
COPY config/php/php-fpm.conf /etc/php/php-fpm.conf

# Install WordPress CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && php wp-cli.phar --info \
    && chmod +x wp-cli.phar \
    && sudo mv wp-cli.phar /usr/bin/wp

# Install Composer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }"

ENTRYPOINT ["/sbin/tini", "--"]
