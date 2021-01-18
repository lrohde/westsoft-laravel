#!/bin/bash

echo "Aliasing $FRAMEWORK"
ln -s /etc/nginx/sites/laravel.conf /etc/nginx/sites/enabled.conf

# # Starts FPM
nohup php-fpm -y /usr/local/etc/php-fpm.conf -F -O 2>&1 &

# Starts NGINX!
nginx
