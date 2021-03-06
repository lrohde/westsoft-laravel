FROM  westsoft/php:7.2

# Repository/Image Maintainer
LABEL maintainer="Diego Hernandes <iamhernandev@gmail.com>"

# Reset user to root to allow software install
USER root

# Copy nginx and entry script
COPY nginx.conf /etc/nginx/nginx.conf
COPY ssl.conf /etc/nginx/ssl.conf
COPY sites /etc/nginx/sites
COPY start.sh  /home/start.sh

# Install nginx from dotdeb (already enabled on base image)
RUN echo "--> Installing Nginx" && \
    apk add --update nginx openssl && \
    rm -rf /tmp/* /var/tmp/* /usr/share/doc/* && \
    echo "--> Fixing permissions" && \
    mkdir /var/tmp/nginx && \
    mkdir /var/run/nginx && \
    mkdir /home/ssl && \
    chown -R westsoftware:westsoftware /home/ssl && \
    chown -R westsoftware:westsoftware /var/tmp/nginx && \
    chown -R westsoftware:westsoftware /var/run/nginx && \
    chown -R westsoftware:westsoftware /var/log/nginx && \
    chown -R westsoftware:westsoftware /var/lib/nginx && \
    chmod +x /home/start.sh && \
    chown -R westsoftware:westsoftware /home/westsoftware

# Define the running user
USER westsoftware

# Pre generate some SSL
# YOU SHOULD REPLACE WITH YOUR OWN CERT.
RUN openssl req -x509 -nodes -days 3650 \
   -newkey rsa:2048 -keyout /home/ssl/nginx.key \
   -out /home/ssl/nginx.crt -subj "/C=AM/ST=westsoftware/L=westsoftware/O=westsoftware/CN=*.dev" && \
   openssl dhparam -out /home/ssl/dhparam.pem 2048

# Application directory
WORKDIR "/var/www/app"

# Expose webserver port
EXPOSE 8080

# Starts a single shell script that puts php-fpm as a daemon and nginx on foreground
CMD ["/home/start.sh"]
