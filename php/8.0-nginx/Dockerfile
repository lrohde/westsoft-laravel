FROM php:8.0.1-fpm

# Arguments defined in docker-compose.yml
ARG user=laravel
ARG uid=1000

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Set working directory
WORKDIR /var/www

COPY start.sh  /home/start.sh

RUN echo "--> Installing Nginx" && \
    apt-get update && \
    apt-get install -y -f nginx openssl && \
    rm -rf /tmp/* /var/tmp/* /usr/share/doc/* && \
    echo "--> Fixing permissions" && \
    mkdir /var/tmp/nginx && \
    mkdir /var/run/nginx && \
    mkdir /home/ssl && \
    chown -R $user:$user /home/ssl && \
    chown -R $user:$user /var/tmp/nginx && \
    chown -R $user:$user /var/run/nginx && \
    chown -R $user:$user /var/log/nginx && \
    chown -R $user:$user /var/lib/nginx && \
    chmod +x /home/start.sh && \
    chown -R $user:$user /home/$user

COPY nginx.conf /etc/nginx/nginx.conf
COPY ssl.conf /etc/nginx/ssl.conf
COPY sites /etc/nginx/sites

USER $user

# YOU SHOULD REPLACE WITH YOUR OWN CERT.
RUN openssl req -x509 -nodes -days 3650 \
   -newkey rsa:2048 -keyout /home/ssl/nginx.key \
   -out /home/ssl/nginx.crt -subj "/C=AM/ST=$user/L=$user/O=$user/CN=*.dev" && \
   openssl dhparam -out /home/ssl/dhparam.pem 2048

# Expose webserver port
EXPOSE 8080

# Starts a single shell script that puts php-fpm as a daemon and nginx on foreground
CMD ["/home/start.sh"]