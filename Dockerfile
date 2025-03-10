FROM composer:latest AS composer
WORKDIR /app
COPY ./web .
RUN composer install --optimize-autoloader --no-dev

FROM php:8.4-fpm AS laravel
WORKDIR /var/www/html
COPY ./web .
COPY --from=composer /app/vendor ./vendor
COPY --from=composer /app/composer.lock ./composer.lock
RUN chown -R www-data:www-data /var/www/html
EXPOSE 9000
CMD ["php-fpm"]

FROM nginx:alpine AS nginx
COPY ./infra/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=laravel /var/www/html/public /var/www/html/public
EXPOSE 80