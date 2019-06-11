## Image for PHP develoment

This image by default includes OCI8 extension and other extensions for laravel operations.

For use, execute:

```docker pull westsoft/php:7.2-nginx```

Copy the project files to /var/www/app and run the image (It's recommended to use the [docker-compose](https://docs.docker.com/compose/)):

```docker run --name container_name westsoft/php:7.2-nginx -v .:/var/www/app -e ENVIRONMENTS_VARIABLE```

**Obs:** Don't forget the laravel environments, the application will not run without them.

Execute the laravel commands, firstly composer install:

```docker exec -it container_name composer install```

```docker exec -it container_name php artisan key:generate```

```docker exec -it container_name php artisan migrate```
