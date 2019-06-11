###
# westsoftware
#
# Repository:    PHP
# Image:         CLI/Base
# Version:       7.2.x
# Strategy:      PHP From PHP-Alpine Repository (CODECASTS) (https://php-alpine.codecasts.rocks)
# Base distro:   Alpine 3.9
#
FROM alpine:3.9

# Repository/Image Maintainer
LABEL maintainer="Luan Rohde <luan@westsoftware.com.br>"

# Variables for enabling NewRelic
ENV FRAMEWORK=laravel \
    OPCACHE_MODE="normal" \
    PHP_MEMORY_LIMIT=256M \
    XDEBUG_ENABLED=false \
    NR_ENABLED=false \
    NR_APP_NAME="" \
    NR_LICENSE_KEY="" \
    TERM=xterm-256color \
    COLORTERM=truecolor \
    COMPOSER_PROCESS_TIMEOUT=1200

# Add the ENTRYPOINT script
ADD start.sh /scripts/start.sh
ADD bashrc /home/westsoftware/.bashrc
ADD bashrc /home/bashrc

RUN set -x && \
    # echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade

RUN apk add --update --no-cache \
    wget \
    nginx \
    supervisor \
    bash \
    curl \
    vim \
    unzip \
    sudo \
    g++ \
    gcc \
    make \
    libaio-dev \
    php7 \
    php7-dev \
    php7-fpm \
    php7-ctype \
    php7-session \
    php7-dom \
    php7-zlib \
    php7-simplexml \
    php7-mongodb \
    php7-mbstring \
    php7-zip \
    php7-xmlwriter \
    php7-mcrypt \
    php7-openssl \
    php7-xml \
    php7-json \
    php7-gd \
    php7-opcache \
    php7-pdo \
    php7-pdo_mysql \
    php7-iconv \
    php7-curl \
    php7-phar \
    php7-xmlreader \
    php7-intl \
    php7-pear \
    php7-dom \
    php7-common \
    php7-tokenizer \
    php7-fileinfo \
    gcompat \
    libnsl && \
    rm -rf /var/cache/apk/*


RUN ln -s /usr/lib/libnsl.so.2 /usr/lib/libnsl.so.1

RUN mkdir -p /opt/oci8

COPY ./oci8/instantclient-basic-linux.x64-12.1.0.2.0.zip /opt/oci8
COPY ./oci8/instantclient-sdk-linux.x64-12.1.0.2.0.zip /opt/oci8
COPY ./oci8/oci8-2.1.7.tgz /opt/oci8
RUN cd /opt/oci8 \
    && unzip instantclient-sdk-linux.x64-12.1.0.2.0.zip \
    && unzip instantclient-basic-linux.x64-12.1.0.2.0.zip \
    && cd instantclient_12_1/ \
    && ln -s libclntsh.so.12.1 libclntsh.so \
    && ln -s libocci.so.12.1 libocci.so \
    && cd ../ \
    && tar xzf oci8-2.1.7.tgz \
    && cd oci8-2.1.7 \
    && phpize \
    && ./configure --with-oci8=shared,instantclient,/opt/oci8/instantclient_12_1 \
    && make \
    && make install \
    && echo "extension=oci8.so" >> /etc/php7/conf.d/oci8.ini \
    && cd /opt/oci8 \
    && rm *.zip \
    && rm *.tgz && \
    echo "---> Installing Composer" && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    echo "---> Cleaning up" && \
    rm -rf /tmp/* && \
    echo "---> Adding the westsoftware user" && \
    adduser -D -u 1000 westsoftware && \
    mkdir -p /var/www/app && \
    chown -R westsoftware:westsoftware /var/www && \
    wget -O /tini https://github.com/krallin/tini/releases/download/v0.16.1/tini-static && \
    chmod +x /tini && \
    echo "---> Configuring PHP" && \
    echo "westsoftware  ALL = ( ALL ) NOPASSWD: ALL" >> /etc/sudoers && \
    sed -i "/user = .*/c\user = westsoftware" /etc/php7/php-fpm.d/www.conf && \
    sed -i "/^group = .*/c\group = westsoftware" /etc/php7/php-fpm.d/www.conf && \
    sed -i "/listen.owner = .*/c\listen.owner = westsoftware" /etc/php7/php-fpm.d/www.conf && \
    sed -i "/listen.group = .*/c\listen.group = westsoftware" /etc/php7/php-fpm.d/www.conf && \
    sed -i "/listen = .*/c\listen = [::]:9000" /etc/php7/php-fpm.d/www.conf && \
    sed -i "/;access.log = .*/c\access.log = /proc/self/fd/2" /etc/php7/php-fpm.d/www.conf && \
    sed -i "/;clear_env = .*/c\clear_env = no" /etc/php7/php-fpm.d/www.conf && \
    sed -i "/;catch_workers_output = .*/c\catch_workers_output = yes" /etc/php7/php-fpm.d/www.conf && \
    sed -i "/pid = .*/c\;pid = /run/php/php7.1-fpm.pid" /etc/php7/php-fpm.conf && \
    sed -i "/;daemonize = .*/c\daemonize = yes" /etc/php7/php-fpm.conf && \
    sed -i "/error_log = .*/c\error_log = /proc/self/fd/2" /etc/php7/php-fpm.conf && \
    sed -i "/post_max_size = .*/c\post_max_size = 1000M" /etc/php7/php.ini && \
    sed -i "/upload_max_filesize = .*/c\upload_max_filesize = 1000M" /etc/php7/php.ini && \
    # sed -i "/zend_extension=xdebug/c\;zend_extension=xdebug" /etc/php7/conf.d/00_xdebug.ini && \
    echo "---> Adding Support for NewRelic" && \
    mkdir /tmp/newrelic && \
    cd /tmp/newrelic && \
    wget -r -l1 -nd -A"linux-musl.tar.gz" https://download.newrelic.com/php_agent/release/ && \
    gzip -dc newrelic*.tar.gz | tar xf - && \
    cd newrelic-php5* && \
    rm -f /usr/lib/php7/modules/newrelic.so && \
    cp ./agent/x64/newrelic-20170718.so /usr/lib/php7/modules/newrelic.so && \
    cp ./daemon/newrelic-daemon.x64 /usr/bin/newrelic-daemon && \
    cp ./scripts/newrelic.ini.template /scripts/newrelic.ini && \
    mkdir /var/log/newrelic && \
    chown -R westsoftware:westsoftware /var/log/newrelic && \
    chown -R westsoftware:westsoftware /home/westsoftware && \
    chmod +x /scripts/start.sh && \
    rm -rf /tmp/*

# Define the running user
USER westsoftware

# Application directory
WORKDIR "/var/www/app"

# Environment variables
ENV PATH=/home/westsoftware/.composer/vendor/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Define the entry point that tries to enable newrelic
ENTRYPOINT ["/tini", "--", "/scripts/start.sh"]

# As non daemon and single base image, it may be used as cli container
CMD ["/bin/bash"]
