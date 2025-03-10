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

FROM python:3.9-slim AS flask
WORKDIR /app
COPY ./flask/ .
RUN pip install --no-cache-dir -r requirements.txt gunicorn
EXPOSE 5000
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "main:app"]

